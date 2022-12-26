import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinCard extends StatefulWidget {
  const CoinCard({Key? key, required this.coin}) : super(key: key);

  final CoinModel coin;

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    final cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    _isFavorite = cryptoProvider.favoriteIds.contains(widget.coin.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cryptoProvider = Provider.of<CryptoProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
      ),
      width: size.width,
      height: size.height * 0.1,
      decoration: BoxDecoration(
        color: CustomColors().black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: size.height * 0.04,
              width: size.width * 0.08,
              imageUrl: widget.coin.image,
              placeholder: (context, publicationImage) => const CircularProgressIndicator(),
              errorWidget: (context, publicationImage, error) => const Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: size.width * 0.03,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextPoppins(
                    text: widget.coin.name,
                    fontSize: 18,
                    color: CustomColors().white,
                  ),
                ),
                TextPoppins(
                  text: '${widget.coin.currentPrice.toStringAsFixed(2)} USD',
                  fontSize: 16,
                  color: CustomColors().purple,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              cryptoProvider.toggleFavorite(widget.coin);
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            icon: Icon(
              Icons.star,
              color: cryptoProvider.favoriteIds.contains(widget.coin.id) ? CustomColors().purple : CustomColors().white,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
