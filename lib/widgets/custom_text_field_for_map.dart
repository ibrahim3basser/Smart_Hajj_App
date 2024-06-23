import 'package:flutter/material.dart';

class CustomTextFieldMap extends StatelessWidget {
  const CustomTextFieldMap({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 35,),
        TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: 'Search here',
            fillColor: Colors.white,
            filled: true,
            border: buildBorder(),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ));
  }
}