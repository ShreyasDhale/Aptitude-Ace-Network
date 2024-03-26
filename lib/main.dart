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
  // Vishal Token

  // Messaging.sendPushMessage(
  //     "cmhtWrdkSOWMJ1tY5ulHw2:APA91bHflNrZ6dV0M6SiRVaQWLSRzJm4n-mbw5HPGttKtphpprCKoQzdCiuv5NHUJQa-FFjIyFvCaUq3-fM6-LfmFBhrGWsgM4aH70eok6dTWrERdQo9RphYbXsxVVggjTqstj6w-HAf",
  //     "Hi User Just Loged in",
  //     "Notification Title");
  runApp(const MyApp());
}
