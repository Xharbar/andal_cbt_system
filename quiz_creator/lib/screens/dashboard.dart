import 'package:flutter/material.dart';

import 'package:quiz_creator/screens/login_screen.dart';
import 'package:quiz_creator/screens/quiz_bank.dart';
import 'package:quiz_creator/screens/create_quiz.dart';
import 'package:quiz_creator/screens/score_sheet.dart';

// ==========================================
// 4. MAIN DASHBOARD SHELL
// ==========================================

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;
  bool _loggingOut = false;

  // We instantiate screens here. Since they are Stateful, their state is preserved better.
  final List<Widget> _screens = [
    const QuizBankScreen(),
    const CreateQuizScreen(),
    const StudentScoresScreen(),
  ];

  void _logout() {
    setState(() => _loggingOut = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logging out...')));

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _loggingOut = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TeacherLoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        leading: isDesktop
            ? null
            : Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                child: Image.asset('lib/assets/images/andal_logo_circular.png'),
              ),
        leadingWidth: 50,
        title: const Text("Andal Teacher Admin"),
        // backgroundColor: Theme.of(context).colorScheme.primary,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PopupMenuButton(
              itemBuilder: (menu) => [
                PopupMenuItem(
                  value: "logout",
                  onTap: _loggingOut ? null : _logout,
                  child: const Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 3),
                      Text("Log out"),
                    ],
                  ),
                ),
              ],
              offset: Offset(0, 45),
              child: const CircleAvatar(child: Text("JD")),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Navigation Side Bar (Desktop)
          if (isDesktop)
            NavigationRail(
              extended: true,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (idx) =>
                  setState(() => _selectedIndex = idx),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.library_books_outlined),
                  selectedIcon: Icon(Icons.library_books),
                  label: Text("Quiz Bank"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: Text("Create Quiz"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: Text("Student Scores"),
                ),
              ],
            ),

          if (isDesktop) const VerticalDivider(width: 1),

          // Main Content
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (idx) => setState(() => _selectedIndex = idx),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_books),
                  label: "Bank",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle),
                  label: "Create",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: "Scores",
                ),
              ],
            ),
    );
  }
}
