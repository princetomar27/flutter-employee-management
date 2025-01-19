import 'package:flutter/material.dart';

class InfoAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  const InfoAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(description),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: onTap,
              child: const Text("OKAY"),
            ),
          ],
        ),
      ),
    );
  }
}

void showInfoAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required VoidCallback onTap,
}) {
  showDialog(
    context: context,
    builder: (context) => InfoAlertDialog(
      title: title,
      description: description,
      onTap: onTap,
    ),
  );
}
