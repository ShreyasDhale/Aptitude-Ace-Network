import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/login/QuestionPage.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Home Page",
          style: style.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuestionPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
