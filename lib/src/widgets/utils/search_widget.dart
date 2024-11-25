import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  final String text;
  final bool isNumber;
  const SearchWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.text,
    required this.isNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CustomInputStyle.inputWidth,
      height: CustomInputStyle.inputHeight,
      margin: CustomMargin.marginSymmetricVertical_3,
      padding: CustomPadding.paddingSymmetricInput,
      decoration: CustomInputStyle.inputBoxdecoration,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: searchController,
            keyboardType: isNumber ? TextInputType.number : null,
            style: CustomInputStyle.inputStyle,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: CustomInputStyle.inputHintStyle,
                hintText: text),
          ),
          if (searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.clear,
                size: 36.0,
              ),
              onPressed: () {
                searchController.clear();
                onSearchChanged();
              },
            ),
        ],
      ),
    );
  }
}
