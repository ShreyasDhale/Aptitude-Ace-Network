import 'package:apptitude_ace_network/Admin/AprooveCompany.dart';
import 'package:apptitude_ace_network/Screens/CompanyHome.dart';
import 'package:apptitude_ace_network/Screens/StudentHome.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/login/QuestionPage.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? screen;
  @override
  void initState() {
    super.initState();
    getCurrentScreens();
  }

  void getCurrentScreens() async {
    Widget screen = await getScreen();
    setState(() {
      this.screen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: screen,
    );
  }

  Future<Widget> getScreen() async {
    if (user != null && user!.email == "admin123@gmail.com") {
      return const ApproveRequests();
    } else if (user != null) {
      String? email = user!.email;
      await company.where("email", isEqualTo: email).get().then((snap) {
        if (snap.size == 0) {
          return const StudentHome();
        } else {
          return const CompanyHome();
        }
      });
      return const CompanyHome();
    } else {
      return const QuestionPage();
    }
  }
}
