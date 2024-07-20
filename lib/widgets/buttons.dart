import 'package:flutter/material.dart';

ElevatedButton buildElevatedButton({
  required String label,
  Function()? onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white.withOpacity(0.8),
      shadowColor: Colors.transparent,
    ),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      child: Text(label, style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,),
    ),
  );
}

TextButton buildTextButton({
  required String label,
  TextStyle? style,
Function()? onPressed,
}){
  return TextButton(onPressed: onPressed, child: Text(label, style: style ??
      const TextStyle(color: Colors.black)));
}

