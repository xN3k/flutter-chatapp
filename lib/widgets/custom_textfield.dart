import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  const CustomTextfield({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Theme.of(context).colorScheme.onInverseSurface,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
      ),
    );
  }
}
