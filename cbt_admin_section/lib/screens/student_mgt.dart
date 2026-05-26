import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cbt_admin_section/widgets/add_students_dialog.dart';
import 'package:cbt_admin_section/widgets/no_registered_student.dart';
import 'package:cbt_admin_section/screens/admin_home.dart';

class Student {
  String id;
  String fullName;
  String regNumber;
  String stdClass;
  String currentPasscode;
  bool isActive;

  Student(
    this.id,
    this.fullName,
    this.regNumber,
    this.stdClass,
    this.currentPasscode,
    this.isActive,
  );
}

// ==========================================
// FEATURE: STUDENT MANAGEMENT
// ==========================================

class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({super.key});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  List<String> subjects = [];
  String _selectedClassFilter = "All";

  void _addStudent() async {
    final Student? returnedStudent = await showDialog<Student>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddStudentsDialog(),
    );

    if (returnedStudent != null) {
      setState(() {
        students.add(returnedStudent);
      });
    }
  }

  void _regeneratePasscode(int index) {
    setState(() {
      students[index].currentPasscode = generatePasscode();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "New Passcode for ${students[index].fullName}: ${students[index].currentPasscode}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _selectedClassFilter == "All"
        ? students
        : students.where((s) => s.stdClass == _selectedClassFilter).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => goHome(context),
                icon: Icon(Icons.home_outlined),
                iconSize: 35.0,
              ),
              SizedBox(width: 10.0),
              Text(
                "Student Management",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Spacer(),
              Row(
                children: students.isEmpty
                    ? []
                    : [
                        DropdownMenu<String>(
                          initialSelection: "All",
                          label: const Text("Filter by Class"),
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(
                              value: "All",
                              label: "All Classes",
                            ),
                            DropdownMenuEntry(value: "JSS 1", label: "JSS 1"),
                            DropdownMenuEntry(value: "JSS 2", label: "JSS 2"),
                            DropdownMenuEntry(value: "JSS 3", label: "JSS 3"),
                            DropdownMenuEntry(value: "SSS 1", label: "SSS 1"),
                            DropdownMenuEntry(value: "SSS 2", label: "SSS 2"),
                            DropdownMenuEntry(value: "SSS 3", label: "SSS 3"),
                          ],
                          onSelected: (val) =>
                              setState(() => _selectedClassFilter = val!),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: _addStudent,
                            icon: const Icon(Icons.add),
                            label: const Text("New Student"),
                          ),
                        ),
                      ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              child: students.isEmpty
                  ? Container(
                      constraints: BoxConstraints.expand(),
                      child: NoRegisteredStudent(onAddStudent: _addStudent),
                    )
                  : ListView.separated(
                      itemCount: filteredStudents.length,
                      separatorBuilder: (c, i) => const Divider(),
                      itemBuilder: (context, index) {
                        final s = filteredStudents[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(s.fullName[0].toUpperCase()),
                          ),
                          title: Text(s.fullName),
                          subtitle: Text(
                            "${s.regNumber}\t\u2022\t${s.stdClass}",
                          ),
                          subtitleTextStyle: Theme.of(
                            context,
                          ).textTheme.labelSmall,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: Text(
                                  "Passcode: ${s.currentPasscode}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () => _regeneratePasscode(index),
                                tooltip: "Regenerate Passcode",
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    students.removeWhere(
                                      (item) => item.id == s.id,
                                    );
                                  });
                                },
                                tooltip: "Delete Student",
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Generate random 6-digit code
String generatePasscode() {
  var rng = Random();
  return (rng.nextInt(900000) + 100000).toString();
}

// 2. UPDATE MOCK DATA
final List<Student> students = [
  // Student("1", "John Doe", "REG/2024/0001", "JSS 1", "123456", true),
  // Student("2", "Jane Smith", "REG/2024/0002", "SSS 2", "654321", true),
];
