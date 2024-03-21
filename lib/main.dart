import 'package:apptitude_ace_network/Backend/Firebase/FirebaseMessaging.dart';
import 'package:apptitude_ace_network/MyApp/MaterialApp.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await messaging.getInitialMessage();
  await Messaging.requestPermissions();
  await Messaging.getToken();
  Messaging.initInfo();
  requestPermission();
  runApp(const MyApp());
}
