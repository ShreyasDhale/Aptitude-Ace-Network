import 'dart:ui';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class ExamPage extends StatefulWidget {
  final Map<String, dynamic> testDetails;
  final List<Map<String, dynamic>> questions;
  final Map<String, dynamic> user;
  const ExamPage(
      {super.key,
      required this.testDetails,
      required this.questions,
      required this.user});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  Map<String, dynamic> testDetails = {};
  List<Map<String, dynamic>> questions = [];
  Map<String, dynamic> user = {};
  List<String> answers = [];
  List<bool?> choices = [];
  int currentIndex = 0;

  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
    setState(() {
      testDetails = widget.testDetails;
      questions = widget.questions;
      user = widget.user;
    });
    getAnswers();
    _controller.start();
  }

  void getAnswers() {
    for (int i = 0; i < questions.length; i++) {
      answers.add(questions[i]['answer']);
      choices.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Remaining time",
              style: style.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          CircularCountDownTimer(
            duration: widget.testDetails['duration'] * 60,
            initialDuration: 0,
            controller: _controller,
            width: MediaQuery.of(context).size.width / 7,
            height: MediaQuery.of(context).size.height / 7,
            ringColor: Colors.grey[300]!,
            ringGradient: null,
            fillColor: Colors.purpleAccent[100]!,
            fillGradient: null,
            backgroundColor: Colors.purple[500],
            backgroundGradient: null,
            strokeWidth: 17.0,
            strokeCap: StrokeCap.round,
            textStyle: style.copyWith(
              fontSize: 23.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textFormat: CountdownTextFormat.MM_SS,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onStart: () {
              debugPrint('Countdown Started');
            },
            onComplete: () {
              debugPrint('Countdown Ended');
            },
            onChange: (String timeStamp) {
              print("object");
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              if (duration.inSeconds == 0) {
                return "Start";
              } else {
                return Function.apply(defaultFormatterFunction, [duration]);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.purple),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
