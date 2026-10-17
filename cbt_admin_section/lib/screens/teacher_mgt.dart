import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cbt_admin_section/screens/admin_home.dart';
import 'package:cbt_admin_section/services/teacher_postgres_service.dart';
import 'package:cbt_admin_section/widgets/add_teacher_dialog.dart';
import 'package:cbt_admin_section/widgets/fallback.dart';

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
  List<Teacher> _teachers = [];
  bool showAddPanel = false;
  bool _isLoading = false;
  bool _hasInternetError = false;
  final postgresService = PostgresService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTeachersFromSupabase();
  }

  Future<void> _fetchTeachersFromSupabase() async {
    // if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final List<dynamic> response = await Supabase.instance.client
          .from('teachers')
          .select()
          .order('full_name', ascending: true);

      final List<Teacher> teachers = response.map((teacherData) {
        return Teacher(
          teacherData['id'] as String,
          teacherData['full_name'] as String,
          teacherData['email'] as String,
          teacherData['subject_assigned'] as String? ??
              'N/A', // Default to 'N/A' if null
          '', // Password is not fetched for security reasons
        );
      }).toList();

      if (mounted) {
        setState(() {
          _teachers = teachers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // 2. Check if the error is network-related (Supabase usually throws SocketExceptions for offline)
          if (e.toString().contains('SocketException') ||
              e.toString().contains('Failed host lookup') ||
              e.toString().contains('ClientException')) {
            _hasInternetError = true;
          } else {
            // It's a different error (like RLS or bad query), show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Database Error: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    }
  }

  void _openAddTeacherPanel() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Close",
      // barrierColor: Colors.black.withAlpha(127), // Dims the background
      transitionDuration: const Duration(milliseconds: 500),
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
                    await _fetchTeachersFromSupabase(); // Refresh the list after adding
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
    await _fetchTeachersFromSupabase(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    final filteredTeachers = _searchQuery.isEmpty
        ? _teachers
        : _teachers
              .where((teacher) => teacher.fullName.contains(_searchQuery))
              .toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white70),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              constraints: BoxConstraints(maxWidth: 200),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        SizedBox(
                          height: 50.0,
                          child: FilledButton.icon(
                            onPressed: () => setState(() {
                              _openAddTeacherPanel();
                            }),
                            icon: const Icon(Icons.person_add),
                            label: const Text("Add Teacher"),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        IconButton.filled(
                          onPressed: () {},
                          icon: Icon(Icons.cloud_sync),
                          iconSize: 35.0,
                          tooltip: 'Sync with server',
                        ),
                      ],
                    )
                  : null,
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Card(
                    child: _isLoading
                        ? Container(
                            constraints: BoxConstraints.expand(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  strokeWidth: 10.0,
                                  valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).primaryColor,
                                  ),
                                  backgroundColor: Colors.grey[300],
                                  strokeCap: StrokeCap.butt,
                                ),
                                SizedBox(height: 10.0),
                                Text('Fetching data...'),
                              ],
                            ),
                          )
                        : _hasInternetError
                        ? Fallback(
                            image:
                                'lib/assets/images/no_internet_connection.png',
                            description:
                                'No Internet Connection or Server is Down',
                            onResolve: () {
                              setState(() {
                                _hasInternetError = false;
                                _isLoading = true;
                                _fetchTeachersFromSupabase();
                              });
                            },
                            buttonLabel: 'Retry',
                            buttonIcon: Icons.refresh,
                          )
                        : _teachers.isNotEmpty
                        ? SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 30.0,
                              columns: const [
                                DataColumn(
                                  label: SizedBox(
                                    width: 170,
                                    child: Text("Name"),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 200,
                                    child: Text("Email"),
                                  ),
                                ),
                                DataColumn(label: Text("Subject Assigned")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: filteredTeachers
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
                          )
                        : Fallback(
                            image: 'lib/assets/images/no_teacher.png',
                            description:
                                'No teachers are currently registered. \nPlease click the Add Teacher button below to register a teacher.',
                            onResolve: () => _openAddTeacherPanel(),
                            buttonLabel: 'Add Teacher',
                            buttonIcon: Icons.add_moderator,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
