import 'dart:async';
import 'dart:math';
import 'package:cbt_admin_section/services/student_postgres_service.dart';
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
  List<Student> _students = [];
  String _selectedClassFilter = "All";
  bool _isLoading = true;
  final postgresService = PostgresService();

  Timer? _passcodeTimer;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _loadStudentsFromDb();
    _startTimer();
  }

  @override
  void dispose() {
    _passcodeTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _passcodeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdown > 1) {
            _countdown--;
          } else {
            // Timer hit 0! Reset timer and regenerate ALL passcodes
            _countdown = 60;
            for (var student in _students) {
              student.currentPasscode = generatePasscode();
              _onTimerExpired(student);
            }
          }
        });
      }
    });
  }

  // Call this exact method whenever your 60-second timer reaches 0
  void _onTimerExpired(Student student) async {
    // 1. Generate the new passcode
    String newCode = generatePasscode();

    try {
      // 2. Update it in the PostgreSQL Database
      await postgresService.updateStudentPasscode(student.regNumber, newCode);

      // 3. Update the UI locally
      setState(() {
        student.currentPasscode = newCode;
      });

      // (Optional) Restart your 60-second timer here if it's meant to loop continuously
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update passcode: $e")),
        );
      }
    }
  }

  Future<void> _loadStudentsFromDb() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final students = await postgresService.getStudents();
      if (!mounted) return;
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Show error if DB is down
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("DB Error: $e")));
    }
  }

  void _addStudent() async {
    final Student? newStudent = await showDialog<Student>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddStudentsDialog(),
    );

    if (newStudent != null) {
      if (!mounted) return;
      setState(() => _isLoading = true);
      await postgresService.insertStudent(newStudent);
      if (!mounted) return;
      await _loadStudentsFromDb(); // Refresh list
    }
  }

  void _deleteStudent(String id) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await postgresService.deleteStudent(id);
    if (!mounted) return;
    await _loadStudentsFromDb(); // Refresh list
  }

  void _regeneratePasscode(int index) {
    setState(() {
      _students[index].currentPasscode = generatePasscode();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "New Passcode for ${_students[index].fullName}: ${_students[index].currentPasscode}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _selectedClassFilter == "All"
        ? _students
        : _students.where((s) => s.stdClass == _selectedClassFilter).toList();

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
                children: _students.isEmpty
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
                        const SizedBox(width: 15),
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
              child: _students.isEmpty
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
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _regeneratePasscode(index),
                                tooltip: "Regenerate Passcode",
                              ),
                              SizedBox(width: 10),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      value: _countdown / 60.0,
                                      strokeWidth: 3.5,
                                      backgroundColor: Colors.white.withAlpha(
                                        20,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "$_countdown",
                                    style: TextStyle(
                                      fontSize: 8.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _students.removeWhere(
                                      (item) => item.id == s.id,
                                    );
                                    _deleteStudent(s.id);
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

// Student("1", "John Doe", "REG/2024/0001", "JSS 1", "123456", true),
// Student("2", "Jane Smith", "REG/2024/0002", "SSS 2", "654321", true),
