import 'package:flutter/material.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _resetPasswordKey = GlobalKey<FormState>();
  bool obscureText = true;

  void resetPassword() {
    if (_resetPasswordKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    _emailController.text = widget.email;

    return Dialog(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 400 : 300,
        maxHeight: double.maxFinite,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // insetPadding: !isDesktop ? EdgeInsets.all(16.0) : EdgeInsets.all(32.0),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "lib/assets/images/reset_password.png",
              height: 150,
              width: 150,
            ),
            Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                // color: Color(0xff81287B),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "Enter your email address to receive password reset instructions.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabled: false,
                // label: Text(widget.email),
                labelText: "Email Address",
                // prefixText: userEmail,
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            SizedBox(height: !isDesktop ? 5 : 12),
            Divider(thickness: 1, color: Colors.grey[500]),
            SizedBox(height: !isDesktop ? 5 : 12),
            Form(
              key: _resetPasswordKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: "Enter New Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      if (value != _confirmPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            // Handle password reset logic here
                          },
                          child: const Text("RESET PASSWORD"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("CANCEL"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
