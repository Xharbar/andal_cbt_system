import 'package:cbt_admin_section/screens/admin_login.dart';
import 'package:flutter/material.dart';

import 'package:cbt_admin_section/widgets/navigation_button.dart';
import 'package:cbt_admin_section/screens/admin_dashboard.dart';
import 'package:cbt_admin_section/widgets/fly_in_animation.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  bool _loggingOut = false;
  late AnimationController animationController;

  void _zoomFadeNavigateTo(BuildContext context, Widget targetScreen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 1. The Curve (Smooth ease-out effect)
          final curveAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          // 2. The Zoom (Scale) Animation
          // Starts at 80% size (0.8) and grows to 100% (1.0)
          final scaleAnimation = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(curveAnimation);

          // 3. The Fade (Opacity) Animation
          // Starts completely transparent (0.0) and becomes fully visible (1.0)
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curveAnimation);

          // 4. Combine them
          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child, // The AdminDashboard screen
            ),
          );
        },
        transitionDuration: const Duration(
          milliseconds: 350,
        ), // Slightly longer looks better for zooming
      ),
    );
  }

  void _logout() {
    setState(() => _loggingOut = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logging out...')));

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _loggingOut = false);
        _zoomFadeNavigateTo(context, AdminLoginScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/images/desk-with-books-stationery-clocks.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(70),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/andal_logo_circular.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Admin Home',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Spacer(),
                  SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _loggingOut ? null : () => _logout(),
                      icon: _loggingOut
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(Icons.logout),
                      label: Text(
                        _loggingOut ? 'Logging out...' : 'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        iconColor: WidgetStatePropertyAll(Colors.white),
                        iconSize: WidgetStatePropertyAll(30.0),
                      ),
                    ),
                  ),
                  // ...existing code...
                ],
              ),
              SizedBox(height: 25.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FlyInAnimation(
                        index: 0,
                        controller: animationController,
                        child: NavigationButton(
                          header: 'Students',
                          description:
                              'View and manage student profile information, and password in one place.',
                          image: 'lib/assets/images/students_home.png',
                          actionDesc: 'Manage Students',
                          onClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 0),
                          ),
                          buttonClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: FlyInAnimation(
                        index: 1,
                        controller: animationController,
                        child: NavigationButton(
                          header: 'Exam Sync',
                          description:
                              'Obtain subject questions so they\'re accessible, even without internet.',
                          image: 'lib/assets/images/exam_sync.png',
                          actionDesc: 'Sync Exams',
                          onClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 1),
                          ),
                          buttonClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: FlyInAnimation(
                        index: 2,
                        controller: animationController,
                        child: NavigationButton(
                          header: 'Teachers',
                          description:
                              'Effortlessly create and manage teacher profiles right here.',
                          image: 'lib/assets/images/teachers_home.png',
                          actionDesc: 'Manage Teachers',
                          onClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 2),
                          ),
                          buttonClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: FlyInAnimation(
                        index: 3,
                        controller: animationController,
                        child: NavigationButton(
                          header: 'Scores',
                          description:
                              'Gather scores from ongoing exams and hold onto them for future updates.',
                          image: 'lib/assets/images/scores_home.png',
                          actionDesc: 'View Scores',
                          onClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 3),
                          ),
                          buttonClicked: () => _zoomFadeNavigateTo(
                            context,
                            AdminDashboard(selectedIndex: 3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'developed by the ICT Department, Andal Science Academy.\nCopyright \u00A9 ${DateTime.now().year}. All rights reserved',
                  style: TextTheme.of(context).bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void goHome(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => AdminHome()),
  );
}
