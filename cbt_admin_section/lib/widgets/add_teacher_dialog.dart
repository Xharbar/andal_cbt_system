import 'package:flutter/material.dart';

class AddTeacherDialog {
  String teacherName;
  String email;
  List<String> subjects;
  String password;

  AddTeacherDialog(this.teacherName, this.email, this.subjects, this.password);
}

Future<Widget> addTeacher() async {
  return AlertDialog(
    content: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [Image.asset("name")]),
    ),
  );
}
