import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  
  void showMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message),
      backgroundColor: Colors.red),
    );
  }
}