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

// Firebase Instances

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage bucket = FirebaseStorage.instance;

// Collection References

CollectionReference student = FirebaseFirestore.instance.collection("Student");
CollectionReference company = FirebaseFirestore.instance.collection("Company");
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
