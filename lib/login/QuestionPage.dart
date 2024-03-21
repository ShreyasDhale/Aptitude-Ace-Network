import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/CompanyBranding.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/login/company/login.dart';
import 'package:apptitude_ace_network/login/student/login.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(child: CompanyBranding(imageName: "question.png")),
              Text(
                'Are you a Student or an Organization?',
                style: style.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 30),
              customButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudentLogin()));
                  },
                  text: 'I am a Student',
                  borderRadius: 10,
                  bgColor: Colors.black,
                  height: 60),
              const SizedBox(height: 20),
              customButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompanyLogin()));
                  },
                  text: 'I am an Organization',
                  borderRadius: 10,
                  bgColor: Colors.black,
                  height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
