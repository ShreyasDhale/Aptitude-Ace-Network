import 'package:apptitude_ace_network/Screens/Company/Company.dart';
import 'package:apptitude_ace_network/Screens/Company/CompanyProfile.dart';
import 'package:apptitude_ace_network/Screens/Company/CompanyResults.dart';
import 'package:apptitude_ace_network/Screens/Student/History.dart';
import 'package:apptitude_ace_network/Screens/Student/Profile.dart';
import 'package:apptitude_ace_network/Screens/Student/Student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

Color darkColor = Colors.black;
Color lightColor = Colors.white;

TextStyle style = GoogleFonts.poppins();

User? user = auth.currentUser;

// Pages Lists

List<Widget> pages = const [Company(), CompanyResults(), CompanyProfile()];
List<Widget> pages1 = const [Student(), PastTest(), StudentProfile()];

// Firebase Instances

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage bucket = FirebaseStorage.instance;

// Collection References

CollectionReference student = FirebaseFirestore.instance.collection("Student");
CollectionReference company = FirebaseFirestore.instance.collection("Company");
DocumentReference appLink =
    FirebaseFirestore.instance.collection("Download_Links").doc("AppLink");
CollectionReference test = FirebaseFirestore.instance.collection("Test");
CollectionReference question =
    FirebaseFirestore.instance.collection("Questions");
CollectionReference subject = FirebaseFirestore.instance.collection("Subjects");
CollectionReference companyRequests =
    FirebaseFirestore.instance.collection("CompanyRequests");

// Firebase Messaging Instance

FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin fps = FlutterLocalNotificationsPlugin();
String token = "";

// Permissions

void requestPermission() async {
  try {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
    ].request();
    print(statuses);
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}
