import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:flutter/material.dart';

class CompanyResults extends StatefulWidget {
  const CompanyResults({super.key});

  @override
  State<CompanyResults> createState() => _CompanyResultsState();
}

class _CompanyResultsState extends State<CompanyResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        "Results",
        style: style,
      ),
    );
  }
}
