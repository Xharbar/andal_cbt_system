import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:quiz_creator/screens/create_quiz.dart';

// ==========================================
// DATA MODELS
// ==========================================
class QuizModel {
  String id;
  String title;
  String description;
  int durationMinutes;
  List<QuestionModel> questions;

  QuizModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.durationMinutes,
    required this.questions,
  });
}

// ==========================================
// FEATURE: QUIZ BANK
// ==========================================

class QuizBankScreen extends StatefulWidget {
  const QuizBankScreen({super.key});

  @override
  State<QuizBankScreen> createState() => _QuizBankScreenState();
}

class _QuizBankScreenState extends State<QuizBankScreen> {
  // Being Stateful allows us to easily add search logic or delete logic later
  // that updates the UI instantly.

  List<QuizModel> _quizzes = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Simulate fetching data
    _quizzes = [
      QuizModel(
        id: "1",
        title: "Introduction to Computer Science",
        durationMinutes: 60,
        questions: [],
        // openDate: DateTime.now(),
      ),
      QuizModel(
        id: "2",
        title: "Advanced Mathematics",
        durationMinutes: 90,
        questions: [],
      ),
      QuizModel(
        id: "3",
        title: "General Knowledge 101",
        durationMinutes: 30,
        questions: [],
      ),
    ];
  }

  void _deleteQuiz(String id) {
    setState(() {
      _quizzes.removeWhere((q) => q.id == id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Quiz deleted locally.")));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final filteredQuizzes = _quizzes
        .where(
          (q) => q.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Quiz Bank",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              SizedBox(
                width: isDesktop ? 400 : 190,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search quizzes...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                childAspectRatio: isDesktop ? 3 / 2 : 3 / 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = filteredQuizzes[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 6,
                        color:
                            Colors.primaries[index % Colors.primaries.length],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text("${quiz.durationMinutes} mins"),
                                  visualDensity: VisualDensity.compact,
                                ),
                                PopupMenuButton(
                                  itemBuilder: (c) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text("Edit"),
                                    ),
                                    const PopupMenuItem(
                                      value: 'reuse',
                                      child: Text("Reuse Questions"),
                                    ),
                                    const PopupMenuItem(
                                      value: 'json',
                                      child: Text("Export JSON"),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onTap: () => _deleteQuiz(quiz.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              quiz.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Created: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Divider(height: 1),
                      Container(
                        // color: Colors.grey[50],
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text("View Details"),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
