import 'package:flutter/material.dart';

class ClienteInput extends TextFormField {
  ClienteInput(
    label, {
    String helperText,
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator validator,
    Icon suffixIcon,
    obscureText = false,
  }) : super(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            helperText: helperText,
          ),
        );
}
