import 'package:flutter/material.dart';

class AddTeacherDialog extends StatefulWidget {
  const AddTeacherDialog({super.key});

  @override
  State<AddTeacherDialog> createState() => _AddTeacherDialogState();
}

class _AddTeacherDialogState extends State<AddTeacherDialog> {
  @override
  Widget build(BuildContext context) {
    final newTeacherKey = GlobalKey<FormState>();
    final teacherName = TextEditingController();
    final teacherEmail = TextEditingController();
    final teacherPassword = TextEditingController();
    final confirmPassword = TextEditingController();
    bool obscurePassword = true;

    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              "lib/assets/add_teacher.png",
              fit: BoxFit.contain,
              height: 205,
            ),
            Divider(
              color: Colors.white54,
              thickness: 1.0,
              indent: 8.0,
              endIndent: 8.0,
            ),
            Form(
              key: newTeacherKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: teacherName,
                    decoration: InputDecoration(label: Text("Teacher's Name")),
                  ),
                  TextFormField(
                    controller: teacherEmail,
                    decoration: InputDecoration(label: Text("Teacher's Email")),
                  ),
                  TextFormField(
                    controller: teacherPassword,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      label: Text("Password"),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: confirmPassword,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      label: Text("Confirm Password"),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
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
