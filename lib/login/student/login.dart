import 'package:apptitude_ace_network/Theme/AppTheme.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/CompanyBranding.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/login/Auth.dart';
import 'package:apptitude_ace_network/login/ForgotPassword.dart';
import 'package:apptitude_ace_network/login/student/signup.dart';
import 'package:flutter/material.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<StudentLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Login',
          style: style,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const CompanyBranding(
              imageName: "CompanyLogos.png",
            ),
            customTextfield(
              leading: const Icon(Icons.email),
              controller: _emailController,
              label: "Enter Email",
            ),
            const SizedBox(height: 16.0),
            customPasswordfield(
              leading: const Icon(Icons.password),
              obsicure: visible,
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                  icon: visible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)),
              controller: _passwordController,
              label: "Enter Pass Key Provided",
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const ForgotPassword()))),
                  child: Text(
                    'Forgot Password ?',
                    style: style.copyWith(
                        color: AppTheme.getColor(context), fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            customButton(
              onTap: () => Auth.studentLogin(_emailController.text.trim(),
                  _passwordController.text.trim(), context),
              borderRadius: 20,
              height: 60,
              bgColor: Colors.black,
              text: 'Login',
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const StudentSignup()))),
                  child: Text(
                    'Not Regestered Yet ? Sign up ?',
                    style: style.copyWith(
                        color: AppTheme.getColor(context), fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
