import 'dart:convert';
import 'dart:io';

import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {
  static Future<void> requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final status = settings.authorizationStatus;

    if (status == AuthorizationStatus.authorized) {
      print("User Granted permission");
    } else if (status == AuthorizationStatus.provisional) {
      print("User Granted Provisonal permissions");
    } else {
      print("User Declined");
    }
  }

  static Future<void> getToken() async {
    await messaging.getToken().then((tok) => token = tok!);
    print(
        "*******************************************************************************\n$token\n******************************************************************************");
  }

  static void initInfo() {
    var androidInitilization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initilizationSettings =
        InitializationSettings(android: androidInitilization);
    fps.initialize(initilizationSettings);
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("..................ON MESSAGE....................");
        print(
            "onMessage: ${message.notification?.title}/${message.notification?.body}");

        BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(message.notification!.body.toString(),
                htmlFormatBigText: true,
                contentTitle: message.notification!.title.toString(),
                htmlFormatContentTitle: true);

        AndroidNotificationDetails androidChannelSpecifics =
            AndroidNotificationDetails("Aptitude_notify", "Aptitude_notify",
                importance: Importance.max,
                styleInformation: bigTextStyleInformation,
                priority: Priority.max,
                playSound: true);

        NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidChannelSpecifics);

        await fps.show(0, message.notification?.title,
            message.notification?.body, platformChannelSpecifics,
            payload: message.data['title']);
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> sendPushMessage(
      String token, String body, String title) async {
    try {
      http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-type': 'application/json',
            'Authorization':
                'key=AAAAJiqKhTI:APA91bGGaKQhD8t0lYchW_vANnbUidqWsUeLyoB3cE0Qe6SY1qDfj1zK_xK5XkdGmOYuSh1DakAffyM07FpSV_0MxX-GuvEt3dP_lTP2sju_tEbSaX5dcoj7cS2mLlYq5FGT8AOlUjUW',
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click-action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'Aptitude_notify'
            },
            'to': token,
          }));
    } on DioException catch (e) {
      // showFailure(context, "msg");
      print(e.message);
    } on HttpException catch (e) {
      print(e.message);
    } on Exception catch (e) {
      print(e);
    }
  }
}
