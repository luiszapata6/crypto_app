import 'package:crypto_app/presentation/utils/constants.dart';
import 'package:flutter/material.dart';

class DropDownButtonWidget extends StatelessWidget {
  const DropDownButtonWidget({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.width,
    required this.hint,
    this.value,
  }) : super(key: key);

  final List<DropdownMenuItem<Object>>? items;
  final Function(Object?)? onChanged;
  final double width;
  final Object? value;
  final Widget? hint;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.0553,
      width: size.width * 0.8,
      child: Material(
        color: CustomColors().white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down_outlined),
              iconSize: 30,
              hint: hint,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
