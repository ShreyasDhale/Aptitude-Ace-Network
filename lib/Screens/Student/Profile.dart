import 'package:flutter/material.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentState();
}

class _StudentState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return Text("Profile");
  }
}
