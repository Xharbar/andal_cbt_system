import 'package:flutter/material.dart';

class NoRegisteredStudent extends StatelessWidget {
  const NoRegisteredStudent({super.key, required this.onAddStudent});

  final VoidCallback onAddStudent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          "lib/assets/images/no_student.png",
          fit: BoxFit.contain,
          height: 300,
          width: 300,
        ),
        Text(
          "No students are currently registered. \nPlease click the Add Student button below to register a student.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 50,
          width: 200,
          child: FilledButton.icon(
            onPressed: onAddStudent,
            label: Text("Add Student", style: TextStyle(fontSize: 16)),
            icon: const Icon(Icons.add, size: 20),
          ),
        ),
      ],
    );
  }
}
