import 'package:apptitude_ace_network/Admin/AprooveCompany.dart';
import 'package:apptitude_ace_network/Screens/Company/CompanyHome.dart';
import 'package:apptitude_ace_network/Screens/Student/StudentHome.dart';
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
    await Future(() => const Duration(seconds: 2));
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
      home: screen, //?? const SplashScreen(),
    );
  }

  Future<Widget> getScreen() async {
    if (user != null && user!.email == "admin123@gmail.com") {
      return const ApproveRequests();
    } else if (user != null) {
      String? email = user!.email;
      return await company.where("email", isEqualTo: email).get().then((snap) {
        if (snap.docs.isEmpty) {
          return const StudentHome();
        } else {
          return const CompanyHome();
        }
      });
    } else {
      return const QuestionPage();
    }
  }
}
