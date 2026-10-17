import 'package:flutter/material.dart';

// import 'package:cbt_admin_section/data/student_scores.dart';
import 'package:cbt_admin_section/screens/admin_home.dart';
import 'package:cbt_admin_section/widgets/fallback.dart';
import 'package:cbt_admin_section/services/student_postgres_service.dart';

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
  final postgresService = PostgresService();
  String _selectedSubject = "All";
  String _selectedClass = "All";
  List<ScoreRecord> _allScores = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getScores();
  }

  Future<void> _getScores() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final scores = await postgresService.getScores();
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _allScores = scores;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occured while getting the scores from server',
          ),
        ),
      );
    }
  }

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
              IconButton(
                onPressed: () => goHome(context),
                icon: Icon(Icons.home_outlined),
                iconSize: 35.0,
              ),
              SizedBox(width: 10.0),
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
              SizedBox(width: 16),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cloud_upload, size: 24),
                  label: const Text("Sync Scores"),
                ),
              ),
              const SizedBox(width: 15),
              IconButton.filled(
                onPressed: () {},
                icon: Icon(Icons.download),
                iconSize: 35,
                tooltip: 'Download Scores',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: _isLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 10.0,
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor,
                            ),
                            backgroundColor: Colors.grey[300],
                            strokeCap: StrokeCap.butt,
                          ),
                          SizedBox(height: 10.0),
                          Text('Fetching data...'),
                        ],
                      )
                    : _allScores.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
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
                                        color: passed
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : Fallback(
                        image: 'lib/assets/images/error_2.png',
                        description: 'No student scores yet.',
                        onResolve: () => _getScores(),
                        buttonLabel: 'Reload',
                        buttonIcon: Icons.refresh,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
