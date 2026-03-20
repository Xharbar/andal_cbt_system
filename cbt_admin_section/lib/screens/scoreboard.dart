import 'package:flutter/material.dart';

class ScoreRecord {
  String regNumber;
  String studentName;
  String studentClass;
  String subject;
  int score;
  int total;

  ScoreRecord(
    this.regNumber,
    this.studentName,
    this.studentClass,
    this.subject,
    this.score,
    this.total,
  );
}

// ==========================================
// FEATURE: SCOREBOARD
// ==========================================

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  String _selectedSubject = "All";
  String _selectedClass = "All";

  final List<ScoreRecord> _allScores = [
    ScoreRecord("REG001", "John Doe", "SSS 3", "Mathematics", 85, 100),
    ScoreRecord("REG002", "Jane Smith", "SSS 2", "Mathematics", 92, 100),
    ScoreRecord("REG001", "John Doe", "JSS 3", "English", 70, 100),
    ScoreRecord("REG003", "Bob Brown", "JSS 1", "Physics", 45, 100),
    ScoreRecord(
      "REG004",
      "Emmanuel Ayobami Shaba",
      "SSS 1",
      "Chemistry",
      45,
      100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredScores = _allScores.where((s) {
      final bool subjectMatch =
          _selectedSubject == "All" || s.subject == _selectedSubject;
      final bool classMatch =
          _selectedClass == "All" || s.studentClass == _selectedClass;
      return subjectMatch && classMatch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Scoreboard",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              DropdownMenu<String>(
                initialSelection: "All",
                label: const Text("Filter Subject"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "All", label: "All Subjects"),
                  DropdownMenuEntry(value: "Mathematics", label: "Mathematics"),
                  DropdownMenuEntry(value: "English", label: "English"),
                  DropdownMenuEntry(value: "Physics", label: "Physics"),
                ],
                onSelected: (val) => setState(() => _selectedSubject = val!),
              ),
              SizedBox(width: 16),
              DropdownMenu<String>(
                initialSelection: "All",
                label: const Text("Filter Class"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "All", label: "All Classes"),
                  DropdownMenuEntry(value: "JSS 1", label: "JSS 1"),
                  DropdownMenuEntry(value: "JSS 2", label: "JSS 2"),
                  DropdownMenuEntry(value: "JSS 3", label: "JSS 3"),
                  DropdownMenuEntry(value: "SSS 1", label: "SSS 1"),
                  DropdownMenuEntry(value: "SSS 2", label: "SSS 2"),
                  DropdownMenuEntry(value: "SSS 3", label: "SSS 3"),
                ],
                onSelected: (val) => setState(() => _selectedClass = val!),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Scrollbar(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Reg Number")),
                      DataColumn(label: Text("Student Name")),
                      DataColumn(label: Text("Class")),
                      DataColumn(label: Text("Subject")),
                      DataColumn(label: Text("Score")),
                      DataColumn(label: Text("Verdict")),
                    ],
                    rows: filteredScores.map((s) {
                      bool passed = s.score >= 50;
                      return DataRow(
                        cells: [
                          DataCell(Text(s.regNumber)),
                          DataCell(Text(s.studentName)),
                          DataCell(Text(s.studentClass)),
                          DataCell(Text(s.subject)),
                          DataCell(Text("${s.score} / ${s.total}")),
                          DataCell(
                            Text(
                              passed ? "PASS" : "FAIL",
                              style: TextStyle(
                                color: passed ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
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
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cloud_upload),
              label: const Text("Sync Scores to Server"),
            ),
          ),
        ],
      ),
    );
  }
}
