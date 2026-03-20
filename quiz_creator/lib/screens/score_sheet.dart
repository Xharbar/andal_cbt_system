import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

// ==========================================
// DATA MODELS
// ==========================================
class StudentScore {
  final String studentId;
  final String studentName;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final DateTime dateTaken;

  StudentScore(
    this.studentId,
    this.studentName,
    this.quizTitle,
    this.score,
    this.totalQuestions,
    this.dateTaken,
  );
}

// ==========================================
// FEATURE: STUDENT SCORES (StatefulWidget)
// ==========================================
class StudentScoresScreen extends StatefulWidget {
  const StudentScoresScreen({super.key});

  @override
  State<StudentScoresScreen> createState() => _StudentScoresScreenState();
}

class _StudentScoresScreenState extends State<StudentScoresScreen> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  final List<StudentScore> _scores = [
    StudentScore(
      "S101",
      "Alice Johnson",
      "Intro to CS",
      85,
      100,
      DateTime.now().subtract(const Duration(days: 1)),
    ),
    StudentScore(
      "S102",
      "Bob Smith",
      "Intro to CS",
      42,
      100,
      DateTime.now().subtract(const Duration(hours: 5)),
    ),
    StudentScore("S103", "Charlie Brown", "Math 101", 95, 100, DateTime.now()),
    StudentScore("S104", "Diana Prince", "Math 101", 60, 100, DateTime.now()),
  ];

  String _filterName = "";

  // Future<void> _exportCsv() async {
  //   final StringBuffer csvBuffer = StringBuffer();
  //   csvBuffer.writeln("Student ID,Name,Quiz,Score,Total,Date");
  //
  //   for (var s in _scores) {
  //     csvBuffer.writeln(
  //       "${s.studentId},${s.studentName},${s.quizTitle},${s.score},${s.totalQuestions},${s.dateTaken.toIso8601String()}",
  //     );
  //   }
  //
  //   String? output = await FilePicker.platform.saveFile(
  //     dialogTitle: 'Save Scores CSV',
  //     fileName:
  //         'scores_export_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
  //   );
  //
  //   if (output != null) {
  //     final file = File(output);
  //     await file.writeAsString(csvBuffer.toString());
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("Exported to $output")));
  //     }
  //   }
  // }

  Future<void> _exportCsv() async {
    // 1. Generate CSV Content
    final StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln("Student ID,Name,Quiz,Score,Total,Date");

    for (var s in _scores) {
      csvBuffer.writeln(
        "${s.studentId},${s.studentName},${s.quizTitle},${s.score},${s.totalQuestions},${s.dateTaken.toIso8601String()}",
      );
    }

    String fileName =
        'scores_export_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';

    try {
      // 2. CHECK PLATFORM: Mobile vs Desktop
      if (Platform.isAndroid || Platform.isIOS) {
        // --- MOBILE LOGIC (Share Sheet) ---

        // Get the temporary directory
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/$fileName';
        final file = File(path);

        // Write the file
        await file.writeAsString(csvBuffer.toString());

        // Open the Share Sheet
        // This lets the user choose "Save to Files", "Gmail", "Drive", etc.
        await Share.shareXFiles([XFile(path)], text: 'Student Scores Export');
      } else {
        // --- DESKTOP LOGIC (Save As Dialog) ---

        String? output = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Scores CSV',
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: ['csv'],
        );

        if (output != null) {
          final file = File(output);
          await file.writeAsString(csvBuffer.toString());
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Exported to $output")));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error exporting: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final filteredScores = _scores
        .where(
          (s) =>
              s.studentName.toLowerCase().contains(_filterName.toLowerCase()) ||
              s.studentId.toLowerCase().contains(_filterName.toLowerCase()),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Student Performance",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              isDesktop
                  ? FilledButton.icon(
                      onPressed: _exportCsv,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green[800],
                      ),
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        "Export CSV",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: IconButton(
                        onPressed: _exportCsv,
                        icon: Icon(Icons.download, color: Colors.white),
                        tooltip: "Export as CSV",
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters
          Row(
            children: [
              DropdownMenu(
                label: const Text("Filter by Quiz"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'all', label: 'All Quizzes'),
                  DropdownMenuEntry(value: 'cs', label: 'Intro to CS'),
                  DropdownMenuEntry(value: 'math', label: 'Math 101'),
                ],
                onSelected: (val) {},
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _filterName = val),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "Search Student Name/ID",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Data Table
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Scrollbar(
                controller: _verticalScrollController,
                thickness: 3,
                thumbVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    controller: _horizontalScrollController,
                    thickness: 3,
                    thumbVisibility: true,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Quiz")),
                          DataColumn(label: Text("Score")),
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Status")),
                        ],
                        rows: filteredScores.map((s) {
                          final percentage = (s.score / s.totalQuestions) * 100;
                          final passed = percentage >= 50;
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  s.studentId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text(s.studentName)),
                              DataCell(Text(s.quizTitle)),
                              DataCell(Text("${s.score}/${s.totalQuestions}")),
                              DataCell(
                                Text(
                                  DateFormat(
                                    'MMM dd, HH:mm',
                                  ).format(s.dateTaken),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: passed
                                        ? Colors.green.withValues(alpha: 20)
                                        : Colors.red.withValues(alpha: 20),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: passed ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  child: Text(
                                    passed ? "PASS" : "FAIL",
                                    style: TextStyle(
                                      color: passed
                                          ? Colors.green[800]
                                          : Colors.red[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
