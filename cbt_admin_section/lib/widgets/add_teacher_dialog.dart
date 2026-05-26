import 'package:flutter/material.dart';

import 'package:cbt_admin_section/data/classes_subjects.dart';

class AddTeacherDialog extends StatefulWidget {
  const AddTeacherDialog({super.key, required this.onSave});

  final Function(Map<String, dynamic>) onSave;

  @override
  State<AddTeacherDialog> createState() => _AddTeacherDialogState();
}

class _AddTeacherDialogState extends State<AddTeacherDialog> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool obscurePassword = true;

  List<String> allSubjects = {...juniorSubjects, ...seniorSubjects}.toList();
  final List<String> _selectedSubject = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).cardTheme.color,
      ),
      constraints: BoxConstraints(minWidth: 500),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. TEXT FIELDS ---
              const Text(
                "Teacher Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Container(
                padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withAlpha(20),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) => v!.isEmpty ? "Name is required" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (v) =>
                          !v!.contains('@') ? "Enter a valid email" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: passCtrl,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Assign Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword == true
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                        ),
                      ),
                      validator: (v) => v!.length < 6
                          ? "Password must be at least 6 characters"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: confirmPassCtrl,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v!.length < 6) {
                          "Password must be at least 6 characters";
                        }
                        if (passCtrl.text != confirmPassCtrl.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- 2. SUBJECTS GRID ---
              const Text(
                "Assign Subject",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Select the primary subject this teacher will manage.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true, // Needed inside SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Disables inner scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      4.0, // Width to height ratio of the grid boxes
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: allSubjects.length,
                itemBuilder: (context, index) {
                  final subject = allSubjects[index];
                  final isSelected = _selectedSubject.contains(subject);

                  return InkWell(
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selectedSubject.remove(subject);
                      } else {
                        _selectedSubject.add(subject);
                      }
                    }),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.white.withAlpha(10),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                          width: isSelected ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24, // Keep it compact
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedSubject.add(subject);
                                  } else {
                                    _selectedSubject.remove(subject);
                                  }
                                });
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              subject,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30), // Padding for bottom button
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (_selectedSubject.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select at least one subject'),
                          ),
                        );
                        return;
                      }
                      widget.onSave({
                        'name': nameCtrl.text,
                        'email': emailCtrl.text,
                        'password': passCtrl.text,
                        'subject': _selectedSubject.join(", "),
                      });
                    }
                  },
                  icon: Icon(Icons.save, size: 36.0),
                  label: Text("Save", style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  icon: Icon(
                    Icons.cancel,
                    size: 36.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary.withAlpha(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
