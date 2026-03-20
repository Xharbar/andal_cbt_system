import 'package:flutter/material.dart';

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
  final List<Teacher> _teachers = [
    Teacher("1", "Mr. Anderson", "anderson@school.com", "Mathematics"),
    Teacher("2", "Mrs. Roberts", "roberts@school.com", "English"),
  ];

  void _addTeacher() {
    // Simplified add logic
    setState(() {
      _teachers.add(Teacher("3", "New Teacher", "new@school.com", "Physics"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Teacher Management",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              FilledButton.icon(
                onPressed: _addTeacher,
                icon: const Icon(Icons.person_add),
                label: const Text("Add Teacher"),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Subject Assigned")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: _teachers
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
        ],
      ),
    );
  }
}
