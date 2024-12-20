import 'package:flutter/material.dart';

void showFloatingNotification(BuildContext context, String title, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          tileColor: Colors.orange[100],
          leading: const Icon(Icons.notifications, color: Colors.orange),
          title: Text(title),
          subtitle: Text(message),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
}
