import 'package:flutter/material.dart';

import 'package:quiz_creator/widgets/question_editor_card.dart';
import 'package:quiz_creator/widgets/classes_n_subjects.dart';
import 'package:quiz_creator/widgets/convert_to_pdf.dart';

// ==========================================
// DATA MODEL
// ==========================================
class QuestionModel {
  String id;
  String text;
  String? imagePath;
  List<String> options;
  List<String> optionImagePath;
  int correctOptionIndex;

  QuestionModel({
    required this.id,
    required this.text,
    this.imagePath,
    required this.optionImagePath,
    required this.options,
    required this.correctOptionIndex,
  }); // : optionImagePath = optionImagePath ?? [?null, ?null, ?null, ?null];
}

// ==========================================
// FEATURE: CREATE QUIZ
// ==========================================

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  String? _selectedClass;
  List<String> subjects = [];
  final _titleCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: "30");
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _addBtnKey = GlobalKey();
  bool _showFab = false;
  bool _showBackToTop = false;

  final List<QuestionModel> _questions = [];

  @override
  void initState() {
    super.initState();
    // 2. LISTEN TO SCROLL EVENTS
    _scrollController.addListener(_checkButtonVisibility);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _addEmptyQuestion() {
    setState(() {
      _questions.add(
        QuestionModel(
          id: DateTime.now().toString(),
          text: "",
          options: ["", "", "", ""],
          optionImagePath: ["", "", "", ""],
          correctOptionIndex: 0,
        ),
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _checkButtonVisibility() {
    // If the button hasn't rendered yet, do nothing
    if (_addBtnKey.currentContext == null) return;

    final RenderBox renderBox =
        _addBtnKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    // Get the screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // Accurate RenderBox Check:
    bool isVisible =
        position.dy > 0 && position.dy < screenHeight - 50; // 50 is buffer
    bool shouldShowScrollToTop = _scrollController.offset > 300;

    // Only call setState if something actually changed to avoid rebuilds
    if (_showFab == isVisible || _showBackToTop != shouldShowScrollToTop) {
      setState(() {
        _showFab = !isVisible; // Show FAB only if button is NOT visible
        _showBackToTop = shouldShowScrollToTop; // Show ToTop if scrolled down
      });
    }
  }

  void _saveQuiz() {
    if (_titleCtrl.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill title and add at least one question."),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quiz saved to Database! (Mock)")),
    );
    // Here you would typically reset state
    setState(() {
      // _titleCtrl.clear();
      // _questions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create New Quiz",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                isDesktop
                    ? Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => generatePdf(
                              context: context,
                              examTitle: _titleCtrl.text,
                              subject: _subjectCtrl.text,
                              examClass: _selectedClass!,
                              duration: _durationCtrl.text,
                              questions: _questions,
                            ),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("Export PDF"),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: _saveQuiz,
                            icon: const Icon(Icons.save),
                            label: const Text("Save Quiz"),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: IconButton(
                              onPressed: () => generatePdf(
                                context: context,
                                examTitle: _titleCtrl.text,
                                subject: _subjectCtrl.text,
                                examClass: _selectedClass!,
                                duration: _durationCtrl.text,
                                questions: _questions,
                              ),
                              icon: const Icon(Icons.picture_as_pdf),
                              // label: const Text("Export PDF"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: IconButton(
                              onPressed: _saveQuiz,
                              icon: Icon(
                                Icons.save,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              // label: const Text("Save Quiz"),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "1. Basic Configuration",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),

            // Configuration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: "Quiz Title",
                        hintText: "e.g. First Examination 2025/2026",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.subject),
                        labelText: "Subject",
                        hintText: "e.g. Biology",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              label: Text("Class", overflow: TextOverflow.fade),
                              prefixIcon: Icon(Icons.class_outlined),
                            ),
                            initialValue: _selectedClass,
                            items: allClasses.map((String userClass) {
                              return DropdownMenuItem<String>(
                                value: userClass,
                                child: Text(userClass),
                              );
                            }).toList(),
                            onChanged: (newClass) {
                              setState(() {
                                _selectedClass = newClass;
                                // if (newClass!.contains('JSS')) {
                                //   subjects = juniorSubjects;
                                // } else {
                                //   subjects = seniorSubjects;
                                // }
                              });
                            },
                            validator: (uClass) => uClass == null
                                ? 'Please select your class'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            controller: _durationCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.timer),
                              labelText: "Duration",
                              suffixText: "mins",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Questions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "2. Questions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  key: _addBtnKey,
                  onPressed: _addEmptyQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Question"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_questions.isEmpty)
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage(
                            "lib/assets/images/no_questions.png",
                          ),
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No questions added yet. Click 'Add Question' to begin.",
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ..._questions.asMap().entries.map((entry) {
              int index = entry.key;
              QuestionModel q = entry.value;
              return QuestionEditorCard(
                index: index,
                question: q,
                onDelete: () => setState(() => _questions.removeAt(index)),
              );
            }),

            const SizedBox(height: 50),
          ],
        ),
      ),
      /*floatingActionButton: _showFab
          ? FloatingActionButton.extended(
              onPressed: _addEmptyQuestion,
              label: const Text("Add Question"),
              icon: Icon(Icons.add),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 3,
            )
          : null,*/
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min, // Shrink to fit children
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 1. BACK TO TOP BUTTON (Shown conditionally)
          ?_showBackToTop
              ? FloatingActionButton.small(
                  heroTag:
                      "scroll_top", // Unique tag required for multiple FABs
                  onPressed: _scrollToTop,
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: const Icon(Icons.arrow_upward),
                )
              : null,
          const SizedBox(height: 10), // Space between buttons
          // 2. YOUR EXISTING "ADD QUESTION" BUTTON
          ?_showFab
              ? FloatingActionButton(
                  onPressed: _addEmptyQuestion,
                  // label: const Text(""),
                  // icon: Icon(Icons.add),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 3,
                  child: const Icon(Icons.add),
                )
              : null,
        ],
      ),
    );
  }
}
