import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*  
  Pantalla para comparar cryptos
 */

class CompareScreen extends StatefulWidget {
  const CompareScreen({Key? key}) : super(key: key);

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  bool _isComparing = false;

  @override
  void initState() {
    final cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cryptoProvider.setFirstSelectedCoin = null;
      cryptoProvider.setSecondSelectedCoin = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cryptoProvider = Provider.of<CryptoProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Visibility(
          visible: !_isComparing,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              const TextPoppins(text: 'Selecciona cryptos y compáralas', fontSize: 20, fontWeight: FontWeight.bold),
              SizedBox(
                height: size.height * 0.15,
              ),
              Visibility(
                visible: cryptoProvider.firstSelectedCoin == null,
                child: SearchWidget(
                  showFilter: false,
                  hintText: 'Busca una crypto',
                  onChanged: (value) => cryptoProvider.searchCoins(value, cryptoProvider.homeController),
                  pageController: cryptoProvider.homeController,
                  onSelected: (SuggestionModel selectedSuggestion) {
                    cryptoProvider.setFirstSelectedCoin = selectedSuggestion;
                  },
                ),
              ),
              if (cryptoProvider.firstSelectedCoin != null)
                Visibility(
                  visible: cryptoProvider.firstSelectedCoin != null,
                  child: CoinChipWidget(
                    selectedCoin: cryptoProvider.firstSelectedCoin!,
                    onTap: () => cryptoProvider.setFirstSelectedCoin = null,
                  ),
                ),
              SizedBox(
                height: size.height * 0.05,
              ),
              const TextPoppins(text: 'vs', fontSize: 20, fontWeight: FontWeight.bold),
              SizedBox(
                height: size.height * 0.05,
              ),
              Visibility(
                visible: cryptoProvider.secondSelectedCoin == null,
                child: SearchWidget(
                  showFilter: false,
                  hintText: 'Busca una crypto',
                  onChanged: (value) => cryptoProvider.searchCoins(value, cryptoProvider.homeController),
                  pageController: cryptoProvider.homeController,
                  onSelected: (SuggestionModel selectedSuggestion) {
                    cryptoProvider.setSecondSelectedCoin = selectedSuggestion;
                  },
                ),
              ),
              if (cryptoProvider.secondSelectedCoin != null)
                CoinChipWidget(
                  selectedCoin: cryptoProvider.secondSelectedCoin!,
                  onTap: () => cryptoProvider.setSecondSelectedCoin = null,
                ),
              SizedBox(
                height: size.height * 0.08,
              ),
              StaticButton(
                text: 'Comparar',
                onPressed: () {
                  if (cryptoProvider.firstSelectedCoin != null && cryptoProvider.secondSelectedCoin != null) {
                    setState(() => _isComparing = true);
                    cryptoProvider.getComparedCoins();
                  } else {
                    Utils.showSnackBar('Selecciona dos cryptos para compararlas', Colors.red);
                  }
                },
                width: size.width * 0.7,
                height: size.height * 0.055,
              )
            ],
          ),
        ),
        Visibility(
          visible: _isComparing,
          child: Column(
            children: [
              Row(
                children: [
                  if (cryptoProvider.selectedLeftCoin != null) CompareCard(coin: cryptoProvider.selectedLeftCoin!),
                  Column(
                    children: [
                      const TextPoppins(text: 'vs', fontSize: 18, fontWeight: FontWeight.w600),
                      SizedBox(height: size.height * 0.005),
                      Icon(
                        Icons.compare_arrows,
                        color: CustomColors().white,
                      ),
                    ],
                  ),
                  if (cryptoProvider.selectedRightCoin != null) CompareCard(coin: cryptoProvider.selectedRightCoin!),
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              StaticButton(
                text: 'Comparar otros',
                onPressed: () {
                  cryptoProvider.setFirstSelectedCoin = null;
                  cryptoProvider.setSecondSelectedCoin = null;
                  setState(() => _isComparing = false);
                },
                width: size.width * 0.7,
                height: size.height * 0.055,
              )
            ],
          ),
        )
      ],
    );
  }
}
