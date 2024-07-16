// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:classinsight/utils/AppColors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool isValid;
  final ValueChanged<String>? onChanged;
  final String? helperText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.isValid,
    this.helperText,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: false,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: widget.hintText,
        helperText: widget.helperText,
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.black),
        floatingLabelStyle: TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: widget.isValid ? Colors.black : Colors.red,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: AppColors.appLightBlue, // Use your AppColors.appLightBlue here
            width: 2.0,
          ),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
