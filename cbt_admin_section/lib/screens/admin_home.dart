import 'package:flutter/material.dart';

import 'package:cbt_admin_section/widgets/navigation_button.dart';
import 'package:cbt_admin_section/screens/admin_dashboard.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  void goToDashboard() {
    setState(() {});
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
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/andal_logo_circular.png',
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Admin Home',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: NavigationButton(
                        header: 'Students',
                        description:
                            'View and manage student profile details, and password.',
                        image: 'lib/assets/images/students_home.jpeg',
                        actionDesc: 'Manage Students',
                        onClicked: () {},
                        buttonClicked: () {},
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: NavigationButton(
                        header: 'Subjects',
                        description:
                            'Obtain subject questions so they\'re accessible, even without internet.',
                        image: 'lib/assets/images/subjects_home.jpeg',
                        actionDesc: 'Manage Subjects',
                        onClicked: () {},
                        buttonClicked: () {},
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: NavigationButton(
                        header: 'Teachers',
                        description:
                            'Effortlessly create and manage teacher profiles right here.',
                        image: 'lib/assets/images/teachers_home.jpeg',
                        actionDesc: 'Manage Teachers',
                        onClicked: () {},
                        buttonClicked: () {},
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: NavigationButton(
                        header: 'Scores',
                        description:
                            'Gather scores from ongoing exams and hold onto them for future updates.',
                        image: 'lib/assets/images/scores_home.jpeg',
                        actionDesc: 'View Scores',
                        onClicked: () => print('Gesture Detected'),
                        buttonClicked: () => print('Clicked'),
                      ),
                    ),
                    SizedBox(width: 15.0),
                  ],
                ),
              ),
              /*Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Text(
                  'developed by the ICT Department, Andal Science Academy.\nCopyright \u00A9 ${DateTime.now().year}. All rights reserved',
                  // style: Theme.of(context).textTheme.bodySmall,
                  style: TextStyle(fontSize: 10.0),
                  textAlign: TextAlign.center,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
