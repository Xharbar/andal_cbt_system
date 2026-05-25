import 'package:flutter/material.dart';

import 'package:cbt_admin_section/data/classes_subjects.dart';
import '../screens/student_mgt.dart';

class AddStudentsDialog extends StatefulWidget {
  const AddStudentsDialog({super.key});

  @override
  State<AddStudentsDialog> createState() => _AddStudentsDialogState();
}

class _AddStudentsDialogState extends State<AddStudentsDialog> {
  final nameCtrl = TextEditingController();
  final regCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final _newStudentKey = GlobalKey<FormState>();
  String? _selectedClass;
  String idPrefix = 'ASA/KN/NG/';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: const Text("Register Student"),
      constraints: BoxConstraints(maxWidth: 400, maxHeight: 700),
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/images/register_student.png",
              fit: BoxFit.contain,
              height: 205,
            ),
            SizedBox(height: 10.0),
            Divider(
              thickness: 1,
              color: Colors.white54,
              indent: 8.0,
              endIndent: 8.0,
            ),
            Expanded(
              child: Form(
                key: _newStudentKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Register Student",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: "Full Name"),
                      validator: (name) =>
                          name == null ? "Please, enter your name" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: regCtrl,
                      maxLength: 4,
                      decoration: InputDecoration(
                        labelText: "Reg Number",
                        prefixText: idPrefix,
                      ),
                      validator: (regNo) => regNo == null
                          ? "Please, enter your registration number"
                          : null,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Your Class',
                        prefixIcon: Icon(Icons.class_outlined),
                      ),
                      initialValue: _selectedClass,
                      items: allClasses.map((String userClass) {
                        return DropdownMenuItem<String>(
                          value: userClass,
                          child: Text(userClass),
                        );
                      }).toList(),
                      onChanged: (newClass) {
                        setState(() => _selectedClass = newClass);
                      },
                      validator: (stdClass) =>
                          stdClass == null ? 'Please select your class' : null,
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: () {
                          String studentID = idPrefix + regCtrl.text;
                          if (_newStudentKey.currentState!.validate()) {
                            final newStudent = Student(
                              DateTime.now().toString(),
                              nameCtrl.text,
                              studentID,
                              _selectedClass!,
                              generatePasscode(), // Auto-generate on creation
                              true,
                            );
                            Navigator.pop(context, newStudent);
                          }
                        },
                        icon: Icon(Icons.save, size: 22),
                        label: Text("Save", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primary.withAlpha(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
