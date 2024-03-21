import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/CompanyBranding.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/login/Auth.dart';
import 'package:flutter/material.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController collageController = TextEditingController();

  bool visiblity = false;
  bool loader = false;

  void load(bool isLoading) {
    setState(() {
      loader = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Signup",
          style: style,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const CompanyBranding(imageName: null),
            Image.asset(
              "Assets/Images/student.png",
              width: MediaQuery.of(context).size.width * 0.40,
              height: MediaQuery.of(context).size.width * 0.40,
            ),
            const SizedBox(
              height: 10,
            ),
            customTextfield(
                controller: nameController,
                label: "Enter Your Name",
                leading: const Icon(Icons.person)),
            const SizedBox(
              height: 16,
            ),
            customTextfield(
                controller: emailController,
                label: "Enter Your Email",
                leading: const Icon(Icons.email)),
            const SizedBox(
              height: 16,
            ),
            customTextfield(
                controller: phoneController,
                label: "Enter Your Contact Number",
                leading: const Icon(Icons.phone)),
            const SizedBox(
              height: 16,
            ),
            customTextfield(
                controller: collageController,
                label: "Collage Name",
                leading: const Icon(Icons.people_alt_outlined)),
            const SizedBox(
              height: 16,
            ),
            customPasswordfield(
              controller: passwordController,
              label: "Create Your Password",
              leading: const Icon(Icons.password),
              obsicure: visiblity,
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      visiblity = !visiblity;
                    });
                  },
                  icon: visiblity
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)),
            ),
            const SizedBox(
              height: 32,
            ),
            customButton(
                text: "Signup",
                onTap: () {
                  Auth.studentSignup(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      phoneController.text.trim(),
                      collageController.text.trim(),
                      passwordController.text.trim(),
                      context,
                      load);
                  setState(() {
                    nameController.text = "";
                    emailController.text = "";
                    phoneController.text = "";
                    collageController.text = "";
                    passwordController.text = "";
                  });
                },
                loader: loader,
                bgColor: Colors.black,
                borderRadius: 10,
                height: 60)
          ],
        ),
      ),
    );
  }
}
