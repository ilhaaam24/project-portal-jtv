import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

class ToastService {
  /// Menampilkan toast sukses
  static void showSuccess(
    BuildContext context,
    String message, {
    String? description,
    Widget? action,
  }) {
    CherryToast.success(
      title: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
      ),
      animationType: AnimationType.fromTop,
      toastPosition: Position.top,
      autoDismiss: true,
      toastDuration: const Duration(milliseconds: 1500),
    ).show(context);
  }

  /// Menampilkan toast error
  static void showError(
    BuildContext context,
    String message, {
    String? description,
  }) {
    CherryToast.error(
      title: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            )
          : null,
      animationType: AnimationType.fromTop,
      toastPosition: Position.top,
      autoDismiss: true,
      toastDuration: const Duration(milliseconds: 1500),
    ).show(context);
  }

  /// Menampilkan toast info
  static void showInfo(
    BuildContext context,
    String message, {
    String? description,
  }) {
    CherryToast.info(
      title: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            )
          : null,
      animationType: AnimationType.fromTop,
      toastPosition: Position.top,
      autoDismiss: true,
      toastDuration: const Duration(milliseconds: 1500),
    ).show(context);
  }

  /// Menampilkan toast peringatan
  static void showWarning(
    BuildContext context,
    String message, {
    String? description,
  }) {
    CherryToast.warning(
      title: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            )
          : null,
      animationType: AnimationType.fromTop,
      toastPosition: Position.top,
      autoDismiss: true,
      toastDuration: const Duration(milliseconds: 1500),
    ).show(context);
  }
}
