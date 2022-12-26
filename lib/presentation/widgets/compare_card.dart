import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';

class CompareCard extends StatelessWidget {
  const CompareCard({
    Key? key,
    required this.coin,
  }) : super(key: key);

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors().black,
        ),
        height: size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextPoppins(text: coin.name, fontSize: 24, fontWeight: FontWeight.bold),
            SizedBox(
              height: size.height * 0.05,
            ),
            TextPoppins(text: coin.symbol, fontSize: 20, fontWeight: FontWeight.bold),
            SizedBox(
              height: size.height * 0.05,
            ),
            TextPoppins(text: '${coin.currentPrice} USD', fontSize: 20, fontWeight: FontWeight.w600)
          ],
        ),
      ),
    );
  }
}
