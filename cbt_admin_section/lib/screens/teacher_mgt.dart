import 'package:flutter/material.dart';

import 'package:cbt_admin_section/widgets/no_registered_teacher.dart';
import 'package:cbt_admin_section/widgets/add_teacher_dialog.dart';
import 'package:cbt_admin_section/screens/admin_home.dart';

class Teacher {
  String id;
  String fullName;
  String email;
  String subjectAssigned;

  Teacher(this.id, this.fullName, this.email, this.subjectAssigned);
}

// ==========================================
// FEATURE: TEACHER MANAGEMENT
// ==========================================

class TeacherManagementPage extends StatefulWidget {
  const TeacherManagementPage({super.key});

  @override
  State<TeacherManagementPage> createState() => _TeacherManagementPageState();
}

class _TeacherManagementPageState extends State<TeacherManagementPage> {
  void _addTeacher() async {
    // Simplified add logic
    /*setState(() {
      teachers.add(Teacher("3", "New Teacher", "new@school.com", "Physics"));
    });*/
    final Teacher? returnedTeacher = await showDialog<Teacher>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddTeacherDialog(
        onCancel: () {},
        onSave: (Map<String, dynamic> p1) {},
      ),
    );

    if (returnedTeacher != null) {
      setState(() {
        // teachers.add(returnedTeacher);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => goHome(context),
                icon: Icon(Icons.home_outlined),
                iconSize: 35.0,
              ),
              SizedBox(width: 10.0),
              Text(
                "Teacher Management",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Spacer(),
              ?teachers.isNotEmpty
                  ? SizedBox(
                      height: 50.0,
                      child: FilledButton.icon(
                        onPressed: _addTeacher,
                        icon: const Icon(Icons.person_add),
                        label: const Text("Add Teacher"),
                      ),
                    )
                  : null,
            ],
          ),
          const SizedBox(height: 24),
          if (teachers.isNotEmpty)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: DataTable(
                          columnSpacing: 30.0,
                          columns: const [
                            DataColumn(
                              label: SizedBox(width: 100, child: Text("Name")),
                            ),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Subject Assigned")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: teachers
                              .map(
                                (t) => DataRow(
                                  cells: [
                                    DataCell(Text(t.fullName)),
                                    DataCell(Text(t.email)),
                                    DataCell(Text(t.subjectAssigned)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Card(
                child: Center(
                  child: NoRegisteredTeacher(onAddTeacher: _addTeacher),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

List<Teacher> teachers = [
  /*Teacher(
    "1",
    "Mr. Emmanuel Ayobami Shaba Digital Technology",
    "anderson@school.com",
    "Mathematics",
  ),*/
  // Teacher("2", "Mrs. Roberts", "roberts@school.com", "English"),
];
