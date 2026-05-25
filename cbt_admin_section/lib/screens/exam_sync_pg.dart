import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cbt_admin_section/screens/admin_home.dart';

class ExamSyncStatus {
  String subject;
  int questionCount;
  bool isSyncedLocal; // True if downloaded for offline use
  DateTime lastUpdated;

  ExamSyncStatus(
    this.subject,
    this.questionCount,
    this.isSyncedLocal,
    this.lastUpdated,
  );
}

// ==========================================
// FEATURE: EXAM SYNC & PREP
// ==========================================

class ExamSyncPage extends StatefulWidget {
  const ExamSyncPage({super.key});

  @override
  State<ExamSyncPage> createState() => _ExamSyncPageState();
}

class _ExamSyncPageState extends State<ExamSyncPage> {
  final List<ExamSyncStatus> _exams = [
    ExamSyncStatus("Mathematics", 50, true, DateTime.now()),
    ExamSyncStatus(
      "English",
      40,
      false,
      DateTime.now().subtract(const Duration(days: 1)),
    ),
    ExamSyncStatus(
      "Physics",
      30,
      false,
      DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
  late final desktop = MediaQuery.of(context).size.width > 900;

  void _syncExam(int index) async {
    final messenger = ScaffoldMessenger.of(context);

    // Simulate Fetching from Server
    messenger.showSnackBar(
      const SnackBar(content: Text("Fetching questions from Server...")),
    );
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _exams[index].isSyncedLocal = true;
      _exams[index].lastUpdated = DateTime.now();
    });

    messenger.showSnackBar(
      const SnackBar(
        content: Text("Exam synced successfully! Ready for offline use."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => goHome(context),
                  icon: Icon(Icons.home_outlined),
                  iconSize: 35.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  "Exam Preparation & Sync",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () =>
                        _syncExam(0), // For demo, sync the first exam
                    icon: const Icon(Icons.sync),
                    // label: Text(desktop ? "Sync Exams" : ""),
                    label: Text("Sync Exams"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Synchronize & download exams from the cloud server to make them available for students on the local network.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _exams.length,
                itemBuilder: (context, index) {
                  final exam = _exams[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      leading: Icon(
                        exam.isSyncedLocal
                            ? Icons.check_circle
                            : Icons.cloud_download,
                        color: exam.isSyncedLocal ? Colors.green : Colors.grey,
                        size: 30,
                      ),
                      title: Text(
                        exam.subject,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Questions: ${exam.questionCount} • Last Updated: ${DateFormat('MMM dd, HH:mm').format(exam.lastUpdated)}",
                      ),
                      trailing: exam.isSyncedLocal
                          ? OutlinedButton(
                              onPressed: () => _syncExam(index),
                              child: const Text("Re-Sync"),
                            )
                          : FilledButton(
                              onPressed: () => _syncExam(index),
                              child: const Text("Download"),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
