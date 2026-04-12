import 'package:flutter/material.dart';

import 'package:cbt_admin_section/screens/student_mgt.dart';
import 'package:cbt_admin_section/screens/teacher_mgt.dart';
import 'package:cbt_admin_section/screens/exam_sync_pg.dart';
import 'package:cbt_admin_section/screens/scoreboard.dart';

// ==========================================
// MAIN DASHBOARD SHELL
// ==========================================

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    const StudentManagementPage(),
    const TeacherManagementPage(),
    const ExamSyncPage(),
    const ScoreboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) =>
                setState(() => selectedIndex = index),
            extended:
                MediaQuery.of(context).size.width >
                900, // Collapsible on smaller screens
            minExtendedWidth: 190,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Students'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school),
                label: Text('Teachers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.cloud_sync),
                label: Text('Exam Prep'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text('Scores'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _pages[selectedIndex]),
        ],
      ),
    );
  }
}
