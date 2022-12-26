import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

/*  
  Pantalla para visualizar las cryptos favoritas
 */

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    final cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    cryptoProvider.favoriteController = PagingController(firstPageKey: 1);
    cryptoProvider.favoriteController.addPageRequestListener((pageKey) {
      cryptoProvider.getFavoriteCoins(
        pageKey,
        cryptoProvider.favoriteController,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cryptoProvider = Provider.of<CryptoProvider>(context);
    return Column(
      children: [
        const TextPoppins(text: 'Tus cryptos favoritas', fontSize: 20, fontWeight: FontWeight.bold),
        Expanded(
          child: CustomScrollView(
            slivers: [
              PagedSliverList<int, CoinModel>(
                pagingController: cryptoProvider.favoriteController,
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
    cryptoProvider.favoriteController.dispose();
    super.dispose();
  }
}
