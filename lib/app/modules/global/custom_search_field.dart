import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? labelText;

  const CustomSearchField(
      {super.key,
      required this.controller,
      required this.onChanged,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: const Icon(Icons.search_rounded),
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Inter-black',
          fontSize: 14,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
