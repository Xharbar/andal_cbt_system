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
      constraints: BoxConstraints(minWidth: 400, maxWidth: 400, maxHeight: 700),
      content: Column(
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
                  /*Expanded(
                    child: GridView.builder(
                      // SliverGridDelegate controls the number of columns and spacing
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns
                            crossAxisSpacing: 16, // Horizontal space
                            mainAxisSpacing: 16, // Vertical space
                            childAspectRatio:
                                1.1, // Makes the tiles slightly rectangular
                          ),
                      itemCount: 2, // subjects.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withAlpha(50),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.menu_book_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "subjects[index]",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
