import 'package:flutter/material.dart';

class ErrorHandler {
  //go through all custom errors and return the corresponding error message
  static String? errorMessage(dynamic error) {
    if (error == null) {
      return null;
    }
    if (error is Exception) {
      return error.toString();
    }
    // throw unexpected error.
    throw error;
  }

  // Display a SnackBar with the error message
  static void showSnackBar(BuildContext context, dynamic error) {
    if (error == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text('${errorMessage(error)}'),
      ),
    );
  }

  //Display an AlertDialog with the error message
  static void showErrorDialog(BuildContext context, dynamic error) {
    if (error == null) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(errorMessage(error) ?? ''),
        );
      },
    );
  }
}
