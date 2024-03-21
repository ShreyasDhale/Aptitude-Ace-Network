import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/CompanyBranding.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: style,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CompanyBranding(imageName: null),
              Image.asset(
                "Assets/Images/forgot-password.jpg",
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(
                height: 16,
              ),
              customTextfield(
                  controller: emailController,
                  label: "Enter Email",
                  leading: const Icon(Icons.email)),
              const SizedBox(
                height: 25,
              ),
              customButton(
                  text: "Send Reset Request",
                  onTap: () {
                    if (emailController.text.isNotEmpty) {
                      try {
                        auth.sendPasswordResetEmail(
                            email: emailController.text);
                      } on FirebaseAuthException catch (e) {
                        showFailure(context, e.code);
                      } on Exception catch (ex) {
                        showFailure(context, ex.toString());
                      }
                      showSuccess(
                          context, "Request Sent to ${emailController.text}");
                    } else {
                      showFailure(context, "Plese Enter Email");
                    }
                  },
                  bgColor: Colors.black,
                  height: 60,
                  borderRadius: 10),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
