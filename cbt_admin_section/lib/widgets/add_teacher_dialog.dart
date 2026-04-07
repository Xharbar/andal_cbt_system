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
    IconData visibilityIcon = Icons.visibility;

    return AlertDialog(
      constraints: BoxConstraints(minWidth: 1000, maxHeight: 700),
      content: Expanded(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    "lib/assets/images/add_teacher.png",
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                  Divider(
                    color: Colors.white54,
                    thickness: 1.0,
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Register Teacher",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Form(
                      key: newTeacherKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: teacherName,
                            decoration: InputDecoration(
                              label: Text("Teacher's Name"),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: teacherEmail,
                            decoration: InputDecoration(
                              label: Text("Teacher's Email"),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: teacherPassword,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              label: Text("Password"),
                              suffixIcon: IconButton(
                                icon: Icon(visibilityIcon),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                    visibilityIcon = Icons.visibility_off;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Divider(
              color: Colors.white54,
              thickness: 1.0,
              indent: 8.0,
              endIndent: 8.0,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    "lib/assets/images/add_teacher.png",
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                  Divider(
                    color: Colors.white54,
                    thickness: 1.0,
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Register Teacher",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Form(
                      // key: newTeacherKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: teacherName,
                            decoration: InputDecoration(
                              label: Text("Teacher's Name"),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: teacherEmail,
                            decoration: InputDecoration(
                              label: Text("Teacher's Email"),
                            ),
                          ),
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
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
    );
  }
}
