import 'package:flutter/material.dart';

Container buildContainer({
  double? width,
  double? height,
  EdgeInsets? padding,
  ImageProvider? image,
  required Widget child,
}) {
  return Container(
    width: width,
    height: height,
    padding: padding,
    decoration: BoxDecoration(
      image: image != null
          ? DecorationImage(
        image: image,
        fit: BoxFit.cover, // Adjust fit as needed
      )
          : null,
      borderRadius: BorderRadius.circular(10),
      color: Colors.white.withOpacity(0.8),
      boxShadow: const [
        BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 5)
      ],
    ),
    child: child,
  );
}
