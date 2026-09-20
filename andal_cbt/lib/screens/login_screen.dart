import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:andal_cbt/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:andal_cbt/screens/exam_screen.dart';
import 'package:andal_cbt/app_data/classes_n_subjects.dart';
import 'package:andal_cbt/widgets/request_password_dialog.dart';
import 'package:andal_cbt/widgets/settings_dialog.dart';
import 'package:andal_cbt/widgets/error_alert.dart';
import 'dart:io';
import 'package:andal_cbt/app_data/student_db_service.dart';

// ==========================================
// 3. Login Screen
// ==========================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _selectedClass;
  String? _selectedSubject;
  List<String> subjects = [];
  bool hidden = true;
  // IconData eyeIcon = FontAwesomeIcons.eye;
  final String prefixId = 'ASA/KN/NG/';
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _serverIp = TextEditingController();
  bool _isLoading = false;
  final dbService = StudentDbService();

  void _requestPassword() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Form(
          key: _passKey,
          child: RequestPasswordDialog(
            controller: _passController,
            image: 'lib/assets/password.png',
            title: 'Authentication',
            content: 'Enter your passcode to authenticate your entry',
            onAuthenticate: () {
              setState(() {
                /*_loginStudent(
                    studentId: "$prefixId${_userController.text.trim()}",
                    studentClass:
                        "${_selectedClass?.replaceAll(' ', '').toLowerCase()}",
                    passCode: _passController.text,
                  );*/
                _handleLogin();
              });
            },
            onCancel: () {
              setState(() {
                _passController.clear();
                Navigator.of(context).pop();
              });
            },
          ),
        ),
      );
    }
  }

  void showBlurredLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(50),
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loader(),
                SizedBox(height: 10.0),
                Text(
                  'Logging In...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    String studentId = '$prefixId${_userController.text.trim()}';
    if (_passKey.currentState!.validate()) {
      showBlurredLoader(context);
      await Future.delayed(Duration(seconds: 2));
      setState(() => _isLoading = true);

      try {
        final studentData = await dbService.loginStudent(
          studentId,
          _passController.text.trim(),
        );

        if (studentData != null) {
          final studentName = studentData['fullName'];
          final studentClass = studentData['className'];

          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Welcome, $studentName!")));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ExamScreen(
                  studentName: '$studentName',
                  studentId: studentId,
                  subject: "$_selectedSubject",
                  studentClass: "$studentClass",
                ),
              ),
            );
          }
        } else if (mounted) {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ErrorAlert(
              image: 'lib/assets/auth_error.png',
              title: 'Authentication Error',
              content:
                  'Invalid Registration Number or Passcode. Check your details and try again \nNote: Passcodes expire every 30 seconds.',
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ErrorAlert(
              image: 'lib/assets/connection_error.png',
              title: 'Connection Error',
              content:
                  'Unable to connect to the server. Please check your network connection, make sure you are connected to the school Wi-Fi and try again.',
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void openServerSettings(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    final serverIp = prefs.getString('server_ip') ?? 'localhost';
    _serverIp.text = serverIp;
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SettingsDialog(
        controller: _serverIp,
        onSave: () {
          prefs.setString('server_ip', _serverIp.text.trim());
          if (Navigator.of(dialogContext).mounted) {
            Navigator.pop(dialogContext);
          }
        },
        onCancel: () {
          _serverIp.clear();
          if (Navigator.of(dialogContext).mounted) {
            Navigator.pop(dialogContext);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // Left Side: Illustration Area
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/login_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              // color: colorScheme.primaryContainer,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/andal_logo_circular.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Andal Science Academy",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Professional Computer-based Examination System.",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),

          // Right Side: Login Form
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.fromLTRB(0.0, 30.0, 30.0, 0.0),
                    height: 45.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: 'Server Settings',
                          onPressed: () => openServerSettings(context),
                          icon: Icon(Icons.settings, size: 28.0),
                        ),
                        SizedBox(width: 10.0),
                        IconButton(
                          tooltip: 'Exit',
                          onPressed: () {
                            exit(0);
                          },
                          icon: Icon(Icons.close, size: 28.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Card(
                      margin: const EdgeInsets.all(24),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Welcome \u{1f642}",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displaySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Aspire to inspire—enter your details to begin your exam.",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                autofocus: true,
                                controller: _userController,
                                maxLength: 4,
                                decoration: InputDecoration(
                                  labelText: "Student ID",
                                  prefixIcon: Icon(Icons.person_outline),
                                  prefixText: prefixId,
                                ),
                                /* onEditingComplete: () {
                                  if (_userController.text.length == 4) {
                                    print('Complete');
                                  }
                                }, */
                                validator: (v) =>
                                    v!.isEmpty ? "Required" : null,
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Select Your Class',
                                  prefixIcon: Icon(Icons.class_outlined),
                                ),
                                initialValue: _selectedClass,
                                items: allClasses.map((String userClass) {
                                  return DropdownMenuItem<String>(
                                    value: userClass,
                                    child: Text(userClass),
                                  );
                                }).toList(),
                                onChanged: (newClass) {
                                  setState(() {
                                    _selectedClass = newClass;
                                    _selectedSubject = null;
                                    if (newClass!.contains('JSS')) {
                                      subjects = juniorSubjects;
                                    } else {
                                      subjects = seniorSubjects;
                                    }
                                  });
                                },
                                validator: (uClass) => uClass == null
                                    ? 'Please select your class'
                                    : null,
                              ),
                              SizedBox(height: 20.0),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Select Subject',
                                  prefixIcon: Icon(Icons.subject_outlined),
                                ),
                                initialValue: _selectedSubject,
                                items: subjects.map((String userSubject) {
                                  return DropdownMenuItem<String>(
                                    value: userSubject,
                                    child: Text(userSubject),
                                  );
                                }).toList(),
                                onChanged: (examSubject) {
                                  setState(
                                    () => _selectedSubject = examSubject,
                                  );
                                },
                                validator: (uClass) => uClass == null
                                    ? 'Please select your class'
                                    : null,
                              ),
                              /**/
                              const SizedBox(height: 60),
                              Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(255, 133, 47, 113),
                                      Color.fromARGB(255, 0, 87, 38),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: FilledButton(
                                  onPressed: _requestPassword,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.play_arrow,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10.0),
                                      const Text("START EXAM"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Text(
                      'developed by the ICT Department, Andal Science Academy.\nCopyright \u00A9 ${DateTime.now().year}. All rights reserved',
                      // style: Theme.of(context).textTheme.bodySmall,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
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
