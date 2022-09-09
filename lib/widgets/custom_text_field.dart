import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({this.onChanged, this.hintText, this.obscureText = false});
  String? hintText;
  Function(String)? onChanged;
  bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: (data) {
        if (data!.isEmpty) {
          return 'required field !';
        }
      },
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: this.hintText,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent))),
    );
  }
}
