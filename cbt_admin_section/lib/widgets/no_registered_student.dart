import 'package:flutter/material.dart';

class NoRegisteredStudent extends StatelessWidget {
  const NoRegisteredStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          "lib/assets/images/no_student.png",
          fit: BoxFit.contain,
          height: 200,
          width: 200,
        ),
        Text(
          "No registered student, click the Add Student button below to register a student.",
        ),
      ],
    );
  }
}
