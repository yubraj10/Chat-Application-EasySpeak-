import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({
  required String labelText,
  required IconData prefixIcon,
  bool isPasswordVisible = false,
  Function()? onPressed,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.black),
    prefixIcon: Icon(prefixIcon, color: Colors.black),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.white,
    suffixIcon: onPressed != null
        ? IconButton(
      onPressed: onPressed,
      icon: Icon(
        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.black,
      ),
    )
        : null,
  );
}


Widget buildTextFormField({
  required TextEditingController controller,
  required String labelText,
  required IconData prefixIcon,
  TextInputType keyboardType = TextInputType.text,
  bool isPasswordVisible = false,
  Function()? onPressed,
  FormFieldValidator<String>? validator,
  TextInputAction textInputAction = TextInputAction.done,
  Function()? onFieldSubmitted,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: isPasswordVisible,
    decoration: buildInputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      isPasswordVisible: !isPasswordVisible,
      onPressed: onPressed,
    ),
    validator: validator,
    textInputAction: textInputAction,
    onFieldSubmitted: (_) => onFieldSubmitted?.call(),
  );
}