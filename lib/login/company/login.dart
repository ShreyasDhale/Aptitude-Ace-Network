import 'package:apptitude_ace_network/Theme/AppTheme.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/CompanyBranding.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/login/Auth.dart';
import 'package:apptitude_ace_network/login/ForgotPassword.dart';
import 'package:apptitude_ace_network/login/company/signup.dart';
import 'package:flutter/material.dart';

class CompanyLogin extends StatefulWidget {
  const CompanyLogin({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<CompanyLogin> {
  bool visible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Company Login',
          style: style,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const CompanyBranding(
              imageName: "recruit.png",
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
              onTap: () => Auth.companyLogin(_emailController.text.trim(),
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
                          builder: ((context) => const CompanySignup()))),
                  child: Text(
                    'Not Regestered Yet ? \nGet Started ?',
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
