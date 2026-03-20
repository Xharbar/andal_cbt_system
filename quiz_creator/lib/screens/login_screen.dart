import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:quiz_creator/screens/dashboard.dart';
import 'package:quiz_creator/widgets/reset_password_dialog.dart';

// ==========================================
// LOGIN SCREEN
// ==========================================

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate Network Delay
      // await Future.delayed(const Duration(seconds: 1));
      try {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _userEmailController.text,
          password: _passwordController.text,
        );

        if (mounted) {
          // setState(() => _isLoading = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardShell()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Failed: Invalid Credentials")),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            // Left Branding Panel (Desktop Only)
            if (isDesktop)
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/assets/images/login_background.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 125,
                        // color: Theme.of(context).colorScheme.primary,
                        color: Colors.white,
                      ),
                      // const SizedBox(height: 0),
                      Text(
                        "Teacher Portal",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Manage Quizzes & Results",
                        style: TextStyle(fontSize: 16, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),

            // Login Form
            Expanded(
              flex: 1,
              child: Container(
                decoration: !isDesktop
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(
                            'lib/assets/images/login_background_mobile1.png',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha(
                              127,
                            ), // Darkens image so text is readable
                            BlendMode.darken,
                          ),
                        ),
                      )
                    : null, // BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                // color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: !isDesktop ? 10 : 40),
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'lib/assets/images/andal_logo.png',
                        fit: BoxFit.contain,
                        width: isDesktop ? 120 : 100,
                        height: isDesktop ? 120 : 100,
                      ),
                    ),
                    ?isDesktop
                        ? null
                        : Text(
                            "Andal Science Academy",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                    ?isDesktop
                        ? null
                        : Text(
                            "CBT Teacher's Portal",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                            ),
                          ),
                    // SizedBox(height: 40),
                    Expanded(
                      flex: 7,
                      child: Center(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: !isDesktop
                                ? const BoxConstraints(maxWidth: 300)
                                : const BoxConstraints(maxWidth: 400),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          "Welcome \u{1F642}",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Log in to continue shaping minds and inspiring futures.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40),

                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _userEmailController,
                                            decoration: const InputDecoration(
                                              labelText: "Email",
                                              prefixIcon: Icon(Icons.email),
                                            ),
                                            validator: (v) {
                                              if (v!.isEmpty) {
                                                return "Required";
                                              } else if (!v.contains('@')) {
                                                return "Invalid Email";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 25),

                                          TextFormField(
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                              labelText: "Password",
                                              prefixIcon: Icon(Icons.lock),
                                              suffixIcon: IconButton(
                                                tooltip: _obscurePassword
                                                    ? 'Show Password'
                                                    : 'Hide Password',
                                                icon: Icon(
                                                  _obscurePassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _obscurePassword =
                                                        !_obscurePassword;
                                                  });
                                                },
                                              ),
                                            ),
                                            obscureText: _obscurePassword,
                                            validator: (v) {
                                              if (v!.isEmpty) {
                                                return "Required";
                                              } else if (v.length < 8) {
                                                return "Password must be at least 8 characters";
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () => showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) =>
                                                    ResetPasswordDialog(
                                                      email:
                                                          _userEmailController
                                                              .text,
                                                    ),
                                              ),
                                              child: Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: isDesktop ? 30 : 20),

                                          SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: FilledButton(
                                              onPressed: _isLoading
                                                  ? null
                                                  : _handleLogin,
                                              child: _isLoading
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          constraints:
                                                              BoxConstraints(
                                                                maxHeight: 20,
                                                                maxWidth: 20,
                                                              ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text("LOGGING IN..."),
                                                      ],
                                                    )
                                                  : const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.login),
                                                        SizedBox(width: 10),
                                                        Text("LOGIN"),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                        child: Text(
                          'developed by the ICT Department, Andal Science Academy.\nCopyright \u00A9 ${DateTime.now().year}. All rights reserved',
                          // style: Theme.of(context).textTheme.bodySmall,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: !isDesktop ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
