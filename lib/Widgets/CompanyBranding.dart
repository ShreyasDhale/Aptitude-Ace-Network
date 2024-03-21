import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyBranding extends StatelessWidget {
  final String? imageName;
  const CompanyBranding({
    super.key,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Apptitude Ace Network",
            style: GoogleFonts.italianno(
                fontWeight: FontWeight.w900, fontSize: 40),
            textAlign: TextAlign.center,
          ),
          if (imageName != null)
            Image.asset(
              "Assets/Images/$imageName",
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
            ),
        ],
      ),
    );
  }
}
