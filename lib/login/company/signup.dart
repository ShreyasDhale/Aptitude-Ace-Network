import 'dart:io';

import 'package:apptitude_ace_network/Theme/AppTheme.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/CompanyBranding.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:apptitude_ace_network/login/Auth.dart';
import 'package:apptitude_ace_network/login/company/login.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CompanySignup extends StatefulWidget {
  const CompanySignup({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<CompanySignup> {
  File? logo;
  File? document;

  String logoName = "Pick Logo For Your Company";
  String docName = "Pick Document for Verification";

  bool uploading = false;
  bool visible = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Company Signup',
          style: style,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const CompanyBranding(
              imageName: null,
            ),
            SizedBox(
              width: 120,
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (logo == null)
                    DottedBorder(
                      dashPattern: const [5, 5],
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: Text("No LOGO")),
                      ),
                    ),
                  if (logo != null)
                    Image.file(
                      logo!,
                      width: 120,
                      height: 70,
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            customTextfield(
              leading: const Icon(Icons.people),
              controller: _nameController,
              label: "Enter Company Name",
            ),
            const SizedBox(height: 16.0),
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
              label: "Create Password",
            ),
            const SizedBox(height: 16.0),
            InkWell(onTap: pickImage, child: picker(logoName)),
            const SizedBox(height: 16.0),
            InkWell(onTap: pickDocument, child: picker(docName)),
            const SizedBox(height: 32.0),
            customButton(
                onTap: () async {
                  if (_nameController.text.trim().isNotEmpty &&
                      _emailController.text.trim().isNotEmpty &&
                      _passwordController.text.trim().isNotEmpty &&
                      logo != null &&
                      document != null) {
                    await Auth.companySignup(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        logo!,
                        document!,
                        context,
                        loading);
                    setState(() {
                      _nameController.text = "";
                      _emailController.text = "";
                      _passwordController.text = "";
                      logo = null;
                      document = null;
                      logoName = "Pick Logo For Your Company";
                      docName = "Pick Document for Verification";
                    });
                  } else {
                    showFailure(context, "Please Fill All The Details");
                  }
                },
                borderRadius: 20,
                height: 60,
                bgColor: Colors.black,
                text: 'Signup',
                loader: uploading),
            const SizedBox(height: 16.0),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompanyLogin())),
                  child: Text(
                    'Log In ?',
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

  void loading(bool isUploading) {
    setState(() {
      uploading = isUploading;
    });
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      File convertedFile = File(result.files.first.path!);
      setState(() {
        logo = convertedFile;
        logoName = convertedFile.path.split("/").last;
      });
    } else {
      return;
    }
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File convertedFile = File(result.files.first.path!);
      setState(() {
        document = convertedFile;
        docName = convertedFile.path.split("/").last;
      });
    } else {
      return;
    }
  }
}
