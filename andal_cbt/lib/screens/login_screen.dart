import 'dart:async';
// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:andal_cbt/screens/exam_screen.dart';
import 'package:andal_cbt/app_data/classes_n_subjects.dart';
import 'package:andal_cbt/custom_widget/request_password_dialog.dart';
// import 'package:postgres/postgres.dart';
// import 'package:http/http.dart' as http;
import 'dart:io';

const String serverUrl = "http://169.254.22.17:5432";

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

  void _handleLogin() {
    // Simulate login delay
    if (_passKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logging in...')));

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ExamScreen(
                studentId: "$prefixId${_userController.text.trim()}",
                subject: "$_selectedSubject",
                studentClass: "$_selectedClass",
              ),
            ),
          );
        }
      });
    }
  }

  /*void _loginFailed({required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }*/

  /*Future<void> _loginStudent({
    required String studentId,
    required String studentClass,
    required String passCode,
  }) async {
    // 1. Establish Connection
    final conn = await Connection.open(
      Endpoint(
        // host: '169.254.22.17',
        host: '192.168.43.107',
        database: 'andal_cbt_db',
        username: 'admin',
        password: 'admin',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    try {
      final result = await conn.execute(
        Sql.named(
          'SELECT full_name FROM ${studentClass}_cbt_login WHERE student_id = @id AND passcode = @passcode',
        ),
        parameters: {'id': studentId, 'passcode': passCode},
        // timeout: Duration(seconds: 5),
      );
      if (result.isNotEmpty) {
        CircularProgressIndicator();
        _handleLogin();
      } else {
        _loginFailed(
          text: 'Login Failed. Ensure that your details are correct.',
        );
      }
    } catch (e) {
      _loginFailed(text: 'Connection Error: Can\'t connect to server');
    } finally {
      await conn.close();
    }
  }*/

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
                    child: IconButton(
                      tooltip: 'Exit',
                      onPressed: () {
                        exit(0);
                      },
                      icon: Icon(Icons.close, size: 28.0),
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
                                    ).textTheme.headlineLarge,
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
                                decoration: InputDecoration(
                                  labelText: "Student ID",
                                  prefixIcon: Icon(Icons.person_outline),
                                  prefixText: prefixId,
                                ),
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
                      style: TextStyle(fontSize: 10.0),
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
