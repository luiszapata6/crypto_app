import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.pageController,
    required this.showFilter,
    required this.onSelected,
    this.onTap,
    this.fontSize,
    this.controller,
  }) : super(key: key);

  final TextEditingController? controller;
  final double? fontSize;
  final PagingController pageController;
  final String hintText;
  final Function(String) onChanged;
  final bool showFilter;
  final Function()? onTap;
  final void Function(SuggestionModel) onSelected;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final cryptoProvider = Provider.of<CryptoProvider>(context);

    return Row(
      mainAxisAlignment: showFilter ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.032),
          height: size.height * 0.0553,
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: const Color.fromRGBO(65, 64, 62, 1),
            ),
          ),
          child: Center(
            child: TypeAheadField(
              hideOnLoading: true,
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              keepSuggestionsOnLoading: false,
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize ?? 16,
                      color: CustomColors().grey,
                    ),
                  ),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: CustomColors().grey,
                  ),
                ),
              ),
              suggestionsCallback: (query) async {
                return cryptoProvider.searchCoins(query, pageController);
              },
              itemBuilder: (context, SuggestionModel suggestion) {
                return ListTile(
                  title: TextPoppins(
                    text: suggestion.name,
                    color: CustomColors().black,
                  ),
                );
              },
              onSuggestionSelected: onSelected,
              noItemsFoundBuilder: (context) {
                return SizedBox(
                  height: size.height * 0.1,
                  child: Center(
                    child: TextPoppins(
                      text: 'No se encontraron coincidencias',
                      color: CustomColors().grey.withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: showFilter,
          child: SizedBox(
            width: size.width * 0.01,
          ),
        ),
        Visibility(
          visible: showFilter,
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),
        Visibility(
          visible: showFilter,
          child: SizedBox(
            width: size.width * 0.013,
          ),
        ),
      ],
    );
  }
}
