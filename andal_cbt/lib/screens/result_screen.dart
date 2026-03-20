import 'package:flutter/material.dart';
import 'package:andal_cbt/screens/login_screen.dart';
import 'package:andal_cbt/app_data/cbt_questions.dart';

// ==========================================
// 5. Results Screen
// ==========================================

class ResultScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<int, int> userAnswers;

  const ResultScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctIndex) {
        score++;
      }
    }

    final percentage = (score / questions.length) * 100;
    final isPassed = percentage >= 60;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // Summary Side
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/result_bg.png'),
                  fit: BoxFit.fill,
                  // repeat: ImageRepeat.repeat,
                ),
              ),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(32),
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage(
                            isPassed
                                ? 'lib/assets/happy_facey.png'
                                : 'lib/assets/sad_facey.png',
                          ),
                          height: 250,
                          width: 250,
                          // color: isPassed ? Colors.green : colorScheme.error,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          isPassed ? "Congratulations!" : "Keep Practicing",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "You scored $score out of ${questions.length}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${percentage.toStringAsFixed(1)}%",
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: isPassed
                                    ? Colors.green
                                    : colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 133, 47, 113),
                                Color.fromARGB(255, 0, 87, 38),
                              ],
                            ),
                          ),
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: Size(250, 50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.home_outlined, size: 28.0),
                                SizedBox(width: 10.0),
                                const Text("EXIT TO HOME"),
                              ],
                            ),
                          ),
                        ),
                      ],
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
