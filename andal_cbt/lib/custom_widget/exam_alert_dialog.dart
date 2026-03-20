import 'package:flutter/material.dart';

class ExamAlertDialog extends StatelessWidget {
  const ExamAlertDialog({
    super.key,
    required this.image,
    required this.title,
    required this.content,
    required this.action,
    required this.buttonText,
  });

  final String image;
  final String title;
  final String content;
  final VoidCallback action;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(32),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. The Image (Time Up Representation)
          Image.asset(image, height: 250, width: 250, fit: BoxFit.contain),
          const SizedBox(height: 24),

          // 2. The Text
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 133, 47, 113),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 45),

          // 3. The Button to Proceed
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 133, 47, 113),
                    Color.fromARGB(255, 0, 87, 38),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: action,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
