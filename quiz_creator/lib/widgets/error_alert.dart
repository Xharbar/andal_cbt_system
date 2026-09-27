import 'dart:ui';

import 'package:flutter/material.dart';

class ErrorAlert extends StatefulWidget {
  const ErrorAlert({
    super.key,
    required this.image,
    required this.title,
    required this.content,
  });

  final String image;
  final String title;
  final String content;

  @override
  State<ErrorAlert> createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
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
                color: Color.fromARGB(255, 133, 47, 113),
              ),
            ),
            SizedBox(height: 10.0),
            Text(widget.content, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            height: 40.0,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 133, 47, 113),
                    Color.fromARGB(255, 0, 87, 38),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
