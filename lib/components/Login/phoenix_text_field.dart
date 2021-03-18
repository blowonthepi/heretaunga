import 'package:flutter/material.dart';

class PhoenixTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String helperText;
  final bool obscureText;
  final TextInputType keyboardType;
  PhoenixTextField({this.controller, this.labelText, this.helperText, this.keyboardType, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          labelText: labelText,
          helperText: helperText,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
          ),
        ),
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
