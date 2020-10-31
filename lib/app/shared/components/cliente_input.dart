import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClienteInput extends TextFormField {
  ClienteInput({
    String label,
    String hintText,
    String helperText,
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator validator,
    int maxLength,
    int lines,
    Icon suffixIcon,
  }) : super(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          minLines: lines ?? 1,
          maxLines: lines ?? 1,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            helperText: helperText,
          ),
        );
}
