import 'package:flutter/material.dart';

class NoRegisteredStudent extends StatelessWidget {
  const NoRegisteredStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("lib/assets/images/no_student.png", fit: BoxFit.contain),
        Text(
          "No registered student, click the Add Student button below to register a student.",
        ),
      ],
    );
  }
}
