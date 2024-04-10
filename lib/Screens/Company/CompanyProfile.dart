import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:flutter/material.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        "Profile",
        style: style,
      ),
    );
  }
}
