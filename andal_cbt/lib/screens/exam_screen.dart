import 'package:flutter/material.dart';
import 'dart:async';
import 'package:andal_cbt/screens/result_screen.dart';
import 'package:andal_cbt/app_data/cbt_questions.dart';
import 'package:andal_cbt/custom_widget/attachment.dart';
import 'package:andal_cbt/custom_widget/exam_alert_dialog.dart';
import 'package:andal_cbt/custom_widget/exam_timer.dart';
import 'package:andal_cbt/custom_widget/battery_indicator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/services.dart';

// ==========================================
// 4. Exam Screen
// ==========================================

class ExamScreen extends StatefulWidget {
  const ExamScreen({
    super.key,
    required this.studentId,
    required this.subject,
    required this.studentClass,
  });

  final String studentId;
  final String subject;
  final String studentClass;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> with WindowListener {
  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {};

  // Timer Logic
  late Timer _timer;
  int _remainingSeconds = 1200; // Time in seconds

  // Battery Logic
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.full;
  StreamSubscription<BatteryState>? _batterySubscription;

  // Custom Colors
  final Color darkGreen = const Color.fromARGB(255, 26, 61, 46); // Darker texts
  final Color accentGreen = const Color.fromARGB(255, 0, 87, 38);

  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  // Get Student Id

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);

    // This effectively disables the Alt+F4 and the "X" button.
    windowManager.setPreventClose(true);
    windowManager.setAlwaysOnTop(true);
    // windowManager.setFullScreen(true);

    // ------------------------------------------------------------
    ServicesBinding.instance.keyboard.addHandler(_onKey);

    // This creates a "Trap" loop. If the user tries to leave, we pull them back.
    // Note: Start Menu might still flash briefly, but this covers it as fast as possible.
    Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      // Constantly assert "Always on Top"
      await windowManager.setAlwaysOnTop(true);
    });

    _startTimer();
    _initBattery();
  }

  void _initBattery() {
    _battery.batteryLevel.then((level) {
      if (mounted) setState(() => _batteryLevel = level);
    });
    _batterySubscription = _battery.onBatteryStateChanged.listen((state) {
      _battery.batteryLevel.then((level) {
        if (mounted) {
          setState(() {
            _batteryState = state;
            _batteryLevel = level;
          });
        }
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);

        // --- INSERT NEW CODE START ---
        // Check battery level every 5 seconds to avoid spamming calls,
        // or every 1 second if you want instant updates.
        if (_remainingSeconds % 2 == 0) {
          _battery.batteryLevel.then((level) {
            if (mounted && level != _batteryLevel) {
              setState(() => _batteryLevel = level);
            }
          });
        }
        // --- INSERT NEW CODE END ---
      } else {
        _timer.cancel();
        // _submitTest();
        _showTimeUpDialog();
      }
    });
  }

  String get _timerText {
    final hours = (_remainingSeconds / 3600).floor().toString().padLeft(2, '0');
    final minutes = ((_remainingSeconds % 3600) / 60)
        .floor()
        .toString()
        .padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$hours : $minutes : $seconds";
  }

  Future<void> _showTimeUpDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must click the button to proceed
      builder: (BuildContext context) {
        return ExamAlertDialog(
          image: 'lib/assets/time_icon.png',
          title: 'Oops! Time\'s Up!',
          content:
              'Your time for this session has expired.\nPlease proceed to view your performance.',
          action: () {
            Navigator.of(context).pop(); // Close the dialog

            // Navigate to Results (Using the ResultScreen from the first iteration)
            // Or simply run your submission logic here:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  questions: mockQuestions,
                  userAnswers: _userAnswers,
                ),
              ),
            );
          },
          buttonText: 'VIEW RESULT',
        );
      },
    );
  }

  void _submitTest() {
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(questions: mockQuestions, userAnswers: _userAnswers),
      ),
    );
  }

  @override
  void dispose() {
    // windowManager.removeListener(this);
    _timer.cancel();
    _batterySubscription?.cancel();
    _scrollController.dispose();
    // ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Questions Navigation.
  void _goToNextQuestion() {
    if (_currentIndex < mockQuestions.length - 1) {
      setState(() => _currentIndex++);

      // SCROLL LOGIC
      // Width of one item (45) + separator (10) = 55.0 pixels
      const double itemSize = 55.0;

      // Calculate the position of the newly selected item
      // We use (_currentIndex + 1) because we want the *end* of the item
      double targetPosition = (_currentIndex + 1) * itemSize;

      // Get current view boundaries
      double currentScroll = _scrollController.offset;
      double viewportWidth = _scrollController.position.viewportDimension;

      // Check if the target is out of view (to the right)
      if (targetPosition > (currentScroll + viewportWidth)) {
        // Scroll by 3 items (3 * 55 = 165 pixels)
        double newOffset = currentScroll + (itemSize * 3);

        // Ensure we don't scroll past the end
        if (newOffset > _scrollController.position.maxScrollExtent) {
          newOffset = _scrollController.position.maxScrollExtent;
        }

        _scrollController.animateTo(
          newOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _goToPreviousQuestion() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);

      // SCROLL LOGIC
      // Width of one item (45) + separator (10) = 55.0 pixels
      const double itemSize = 55.0;

      // Calculate the position of the newly selected item
      // We use (_currentIndex + 1) because we want the *end* of the item
      double targetPosition = _currentIndex * itemSize;

      // Get current view boundaries
      double currentScroll = _scrollController.offset;

      // Check if the target is out of view (to the right)
      if (targetPosition < currentScroll) {
        // Scroll by 3 items (3 * 55 = 165 pixels)
        double newOffset = currentScroll - (itemSize * 3);

        // Ensure we don't scroll past the end
        if (newOffset < 0) {
          newOffset = 0;
        }

        _scrollController.animateTo(
          newOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 1. Blocks Alt+F4
  @override
  void onWindowClose() {
    // We do nothing here, which effectively ignores the close request.
    // Optionally show a warning dialog:

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ExamAlertDialog(
        image: 'lib/assets/security_alert.png',
        title: 'Security Alert!',
        content: "Closing the exam is disabled! Submit to exit.",
        action: () => Navigator.of(context).pop(),
        buttonText: 'RESUME',
      ),
    );
  }

  // 2. Detects Alt+Tab or Windows Key (Window loses focus)
  @override
  void onWindowBlur() {
    // When the user switches windows or opens the Start menu:
    // 1. Immediately bring app back to front
    // windowManager.focus();

    // 2. Show a warning or log the cheating attempt
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ExamAlertDialog(
        image: 'lib/assets/security_alert.png',
        title: 'Security Alert!',
        content:
            'Navigating away from this window is prohibited.\nYour attempt has been recorded.',
        action: () => Navigator.of(context).pop(),
        buttonText: 'RESUME',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INSERT THIS METHOD in _ExamScreenState
  bool _onKey(KeyEvent event) {
    final key = event.logicalKey;
    if (event is KeyDownEvent) {
      if (key == LogicalKeyboardKey.meta ||
          key == LogicalKeyboardKey.metaLeft ||
          key == LogicalKeyboardKey.metaRight ||
          key == LogicalKeyboardKey.alt) {
        // Return true to tell the system we handled it
        return true;
      }
    }
    return false;
  }

  void _showAttachedImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Attachment(imageUrl: mockQuestions[_currentIndex].imageUrl!);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Main App Interface.
  @override
  Widget build(BuildContext context) {
    final question = mockQuestions[_currentIndex];
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      // Gradient Background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 133, 47, 113),
              Color.fromARGB(255, 0, 87, 38),
            ],
          ),
        ),
        child: Column(
          children: [
            // Top Header (Logo + Profile)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "lib/assets/andal_logo_circular.png",
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'SUBJECT:',
                            style: TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.subject.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'CLASS:',
                            style: TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.studentClass,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 12.0),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                          'lib/assets/avatar.png',
                        ), // Mock image
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shaba Emmanuel Ayobami",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.studentId,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main White Card Area
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 700.0),
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 35,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        // 1. Timer, Battery & Submit Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // TIMER
                                ExamTimer(examTime: _timerText),

                                // BATTERY INSERTION
                                BatteryIndicator(
                                  icon: _batteryState == BatteryState.charging
                                      ? Icons.battery_charging_full
                                      : Icons.battery_std,
                                  iconColor: _batteryLevel < 20
                                      ? Colors.red
                                      : Colors.green[800],
                                  batteryLevel: "$_batteryLevel%",
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: _submitTest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // 2. Question Content & Circular Progress
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Side: Question + Options Grid
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Question ${_currentIndex + 1} of ${mockQuestions.length}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            question.text,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              height: 1.3,
                                            ),
                                          ),
                                          if (question.imageUrl != null &&
                                              question
                                                  .imageUrl!
                                                  .isNotEmpty) ...[
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextButton.icon(
                                                onPressed: () {
                                                  setState(() {
                                                    /*Attachment(
                                                  imageUrl: question.imageUrl!,
                                                );*/
                                                    _showAttachedImage();
                                                  });
                                                },
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 1,
                                                        vertical: 12,
                                                      ),
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                icon: Icon(
                                                  Icons.image_outlined,
                                                  color: accentGreen,
                                                ),
                                                label: Text(
                                                  "Click here to view the image",
                                                  style: TextStyle(
                                                    color: accentGreen,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline, // Visual cue that it's clickable
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 40),

                                          // Grid for Options (A, B, C, D)
                                          Expanded(
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                // Calculate width for 2 columns with spacing
                                                final double itemWidth =
                                                    (constraints.maxWidth -
                                                        20) /
                                                    2;

                                                return Wrap(
                                                  spacing: 20,
                                                  runSpacing: 20,
                                                  children: List.generate(question.options.length, (
                                                    index,
                                                  ) {
                                                    final isSelected =
                                                        _userAnswers[_currentIndex] ==
                                                        index;
                                                    final labels = [
                                                      "A",
                                                      "B",
                                                      "C",
                                                      "D",
                                                    ];

                                                    return SizedBox(
                                                      width: itemWidth,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _userAnswers[_currentIndex] =
                                                                index;
                                                          });
                                                        },
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 20,
                                                                vertical: 24,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                              color: isSelected
                                                                  ? accentGreen
                                                                  : Colors
                                                                        .grey[300]!,
                                                              width: isSelected
                                                                  ? 2
                                                                  : 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${labels[index]}.",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                question
                                                                    .options[index],
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right Side: Circular Progress
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CircularProgressIndicator(
                                          value:
                                              _userAnswers.length /
                                              mockQuestions.length,
                                          strokeWidth: 15,
                                          backgroundColor: Color.fromARGB(
                                            40,
                                            26,
                                            61,
                                            46,
                                          ),
                                          color: darkGreen,
                                          strokeCap: StrokeCap.round,
                                        ),
                                        Center(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${_userAnswers.length}",
                                                  style: TextStyle(
                                                    fontSize: 48,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "/${mockQuestions.length}",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 3. Bottom Pagination
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 60,
                          child: Row(
                            children: [
                              if (_currentIndex > 0 ||
                                  _currentIndex ==
                                      mockQuestions.length - 1) ...[
                                _paginationBtn(
                                  "Prev",
                                  onTap: _currentIndex > 0
                                      ? _goToPreviousQuestion // <--- Use the new method here
                                      : null,
                                  isText: true,
                                ),
                              ],
                              const SizedBox(width: 16),
                              Expanded(
                                child: ListView.separated(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: mockQuestions.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final isActive = _currentIndex == index;
                                    // 1. Check if the question is answered
                                    final isAnswered = _userAnswers.containsKey(
                                      index,
                                    );

                                    // 2. Determine Colors based on state priority
                                    // Priority: Active > Answered > Default
                                    Color boxColor;
                                    Color textColor;
                                    Color borderColor;

                                    if (isActive) {
                                      boxColor =
                                          darkGreen; // Darkest Green for current position
                                      textColor = Colors.white;
                                      borderColor = darkGreen;
                                    } else if (isAnswered) {
                                      // Lighter Green for answered questions
                                      boxColor = accentGreen.withAlpha(70);
                                      textColor = Colors.black;
                                      borderColor = accentGreen.withAlpha(70);
                                    } else {
                                      boxColor = Colors
                                          .transparent; // White/Transparent for skipped
                                      textColor = Colors.black;
                                      borderColor = Colors.grey[300]!;
                                    }

                                    return InkWell(
                                      onTap: () =>
                                          setState(() => _currentIndex = index),
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color:
                                              boxColor, // <--- Apply the calculated background
                                          border: Border.all(
                                            color: borderColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                              color:
                                                  textColor, // <--- Apply the calculated text color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (_currentIndex < mockQuestions.length - 1) ...[
                                _paginationBtn(
                                  "Next",
                                  onTap:
                                      _currentIndex < mockQuestions.length - 1
                                      ? _goToNextQuestion // <--- Use the new method here
                                      : null,
                                  isText: true,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
              child: Text(
                'developed by ICT Department, Andal Science Academy.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paginationBtn(
    String label, {
    VoidCallback? onTap,
    bool isText = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        /*decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),*/
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: darkGreen,
          ), // Color.fromARGB(170, 26, 61, 46)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
