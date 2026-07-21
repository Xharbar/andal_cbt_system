import 'package:flutter/material.dart';
import 'package:cbt_admin_section/services/teacher_postgres_service.dart';

import 'package:cbt_admin_section/widgets/no_registered_teacher.dart';
import 'package:cbt_admin_section/widgets/add_teacher_dialog.dart';
import 'package:cbt_admin_section/screens/admin_home.dart';

class Teacher {
  String id;
  String fullName;
  String email;
  String subjectAssigned;
  String password;

  Teacher(
    this.id,
    this.fullName,
    this.email,
    this.subjectAssigned,
    this.password,
  );
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
  bool showAddPanel = false;
  bool _isLoading = false;
  final postgresService = PostgresService();

  @override
  void initState() {
    super.initState();
    _loadTeachersFromDb();
  }

  Future<void> _loadTeachersFromDb() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final teachers = await postgresService.getTeachers();
      if (!mounted) return;
      setState(() {
        _teachers = teachers;
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

  void _openAddTeacherPanel() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Close",
      // barrierColor: Colors.black.withAlpha(127), // Dims the background
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Padding(
          padding: EdgeInsetsGeometry.all(20.0),
          child: Align(
            alignment: Alignment.centerRight, // Aligns panel to the right
            child: Material(
              color: Colors.transparent,
              elevation: 16,
              child: SizedBox(
                width: 400, // Fixed width for the side panel
                height: double.infinity, // Full height
                child: AddTeacherDialog(
                  onSave: (newTeacherData) async {
                    // Handle saving the data
                    setState(() {
                      // Add to your list (Assuming you have a _teachers list)
                      _teachers.add(
                        Teacher(
                          DateTime.now().toString(),
                          newTeacherData['name'],
                          newTeacherData['email'],
                          newTeacherData['subject'],
                          newTeacherData['password'],
                        ),
                      );
                    });
                    Navigator.of(context).pop(); // Close panel after save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${newTeacherData['name']} added successfully!",
                        ),
                      ),
                    );

                    if (!mounted) return;
                    setState(() => _isLoading = true);
                    await postgresService.insertTeacher(
                      context,
                      Teacher(
                        DateTime.now().toString(),
                        newTeacherData['name'],
                        newTeacherData['email'],
                        newTeacherData['subject'],
                        newTeacherData['password'],
                      ),
                    );

                    if (!mounted) return;
                    await _loadTeachersFromDb(); // Refresh the list after adding
                  },
                ),
              ),
            ),
          ),
        );
      },
      // This makes it slide in from the right edge
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Starts off-screen to the right
            end: Offset.zero, // Ends at its normal position
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  void _deleteTeacher(String id) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await postgresService.deleteTeacher(id);
    if (!mounted) return;
    await _loadTeachersFromDb(); // Refresh list
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
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Spacer(),
              ?_teachers.isNotEmpty
                  ? SizedBox(
                      height: 50.0,
                      child: FilledButton.icon(
                        onPressed: () => setState(() {
                          _openAddTeacherPanel();
                        }),
                        icon: const Icon(Icons.person_add),
                        label: const Text("Add Teacher"),
                      ),
                    )
                  : null,
              SizedBox(width: 10.0),
              IconButton.filled(
                onPressed: () {},
                icon: Icon(Icons.cloud_sync),
                iconSize: 35.0,
                tooltip: 'Sync with server',
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_teachers.isNotEmpty)
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 30.0,
                          columns: const [
                            DataColumn(
                              label: SizedBox(width: 170, child: Text("Name")),
                            ),
                            DataColumn(
                              label: SizedBox(width: 200, child: Text("Email")),
                            ),
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
                                            onPressed: () {
                                              setState(() {
                                                _teachers.removeWhere(
                                                  (item) =>
                                                      item.email == t.email,
                                                );
                                                _deleteTeacher(t.email);
                                              });
                                            },
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
                  child: NoRegisteredTeacher(
                    onAddTeacher: () => _openAddTeacherPanel(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

List<Teacher> _teachers = [];
