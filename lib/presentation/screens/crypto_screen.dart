import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

/*  
  Pantalla para visualizar el listado de cryptos
  y realizar filtros
 */

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  bool _showFilter = false;

  Future<void> fetchFavorites() async {
    final cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    cryptoProvider.favoriteIds = await cryptoProvider.getFavoritesByUser();
  }

  @override
  void initState() {
    fetchFavorites().then((value) => setState(() {}));
    final cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    cryptoProvider.homeController = PagingController(firstPageKey: 1);
    cryptoProvider.homeController.addPageRequestListener((pageKey) {
      cryptoProvider.getPaginatedCoins(
        pageKey,
        cryptoProvider.homeController,
        'price_desc',
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => cryptoProvider.selectedCoinId = null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final cryptoProvider = Provider.of<CryptoProvider>(context);
    return Column(
      children: [
        SearchWidget(
          showFilter: true,
          hintText: 'Busca una crypto',
          onChanged: (value) => cryptoProvider.searchCoins(value, cryptoProvider.homeController),
          onTap: () => setState(
            () => _showFilter = !_showFilter,
          ),
          pageController: cryptoProvider.homeController,
          onSelected: (SuggestionModel selectedSuggestion) {
            cryptoProvider.selectedCoinId = selectedSuggestion.id;
            cryptoProvider.getCoinById(0, cryptoProvider.homeController, 'price_asc', selectedSuggestion.id);
          },
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Visibility(
          visible: _showFilter,
          child: Padding(
            padding: EdgeInsets.only(right: size.width * 0.065),
            child: DropDownButtonWidget(
              value: cryptoProvider.selectedSortType,
              items: cryptoProvider.sortTypeList.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: TextPoppins(
                    text: value,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: CustomColors().grey,
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                cryptoProvider.homeController.itemList = [];
                await cryptoProvider.getPaginatedCoins(
                  1,
                  cryptoProvider.homeController,
                  value == 'Precio: de mayor a menor' ? 'price_desc' : 'price_asc',
                );
                cryptoProvider.selectedSortType = value as String?;
              },
              width: size.width * 0.9,
              hint: const TextPoppins(
                text: 'Selecciona',
              ),
            ),
          ),
        ),
        Visibility(
          visible: cryptoProvider.selectedCoinId != null,
          child: SizedBox(
            height: size.height * 0.02,
          ),
        ),
        Visibility(
          visible: cryptoProvider.selectedCoinId != null,
          child: LargeButton(
            text: 'Mostrar todas',
            fontSize: 16,
            onPressed: () {
              cryptoProvider.selectedCoinId = null;
              cryptoProvider.getPaginatedCoins(1, cryptoProvider.homeController, 'price_desc');
            },
            width: size.width * 0.42,
            height: size.height * 0.045,
          ),
        ),
        Visibility(
          visible: cryptoProvider.selectedCoinId != null,
          child: SizedBox(
            height: size.height * 0.02,
          ),
        ),
        Visibility(
          visible: _showFilter,
          child: SizedBox(
            height: size.height * 0.02,
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              PagedSliverList<int, CoinModel>(
                pagingController: cryptoProvider.homeController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: ((context, item, index) {
                    return CoinCard(
                      coin: item,
                    );
                  }),
                  noItemsFoundIndicatorBuilder: (context) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    final cryptoProvider = Provider.of<CryptoProvider>(NavigationService.navigatorKey.currentContext!, listen: false);
    cryptoProvider.homeController.dispose();
    super.dispose();
  }
}
