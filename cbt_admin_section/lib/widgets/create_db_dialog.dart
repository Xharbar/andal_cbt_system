import 'dart:ui';

import 'package:flutter/material.dart';

class CreateDbDialog extends StatefulWidget {
  const CreateDbDialog({
    super.key,
    required this.image,
    required this.title,
    required this.content,
    required this.onCreate,
  });

  final String image;
  final String title;
  final String content;
  final VoidCallback onCreate;

  @override
  State<CreateDbDialog> createState() => _CreateDbDialogState();
}

class _CreateDbDialogState extends State<CreateDbDialog> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
      child: AlertDialog(
        constraints: BoxConstraints(maxHeight: 580, maxWidth: 350),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.image,
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 10.0),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 10.0),
            Text(widget.content, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            height: 50.0,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                widget.onCreate;
                Navigator.of(context).pop();
              },
              child: const Text(
                "CREATE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 50.0,
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
