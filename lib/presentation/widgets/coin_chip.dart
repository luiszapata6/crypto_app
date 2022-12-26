import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';

class CoinChipWidget extends StatelessWidget {
  const CoinChipWidget({
    Key? key,
    required this.onTap,
    required this.selectedCoin,
  }) : super(key: key);

  final SuggestionModel selectedCoin;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: Container(
                width: size.width * 0.7,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors().purple),
                  color: CustomColors().black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextPoppins(
                    text: selectedCoin.name,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            right: size.height * 0.06,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
