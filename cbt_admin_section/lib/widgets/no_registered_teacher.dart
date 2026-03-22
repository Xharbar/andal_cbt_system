import 'package:flutter/material.dart';

class NoRegisteredTeacher extends StatelessWidget {
  const NoRegisteredTeacher({super.key, required this.onAddTeacher});

  final VoidCallback onAddTeacher;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          "lib/assets/images/no_teacher.png",
          fit: BoxFit.contain,
          height: 300,
          width: 300,
        ),
        Text(
          "No teachers are currently registered. \nPlease click the Add Teacher button below to register a teacher.",
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
            onPressed: onAddTeacher,
            label: Text("Add Teacher", style: TextStyle(fontSize: 16)),
            icon: const Icon(Icons.person_add, size: 20),
          ),
        ),
      ],
    );
  }
}
