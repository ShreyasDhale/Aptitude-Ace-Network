import 'dart:io';

import 'package:apptitude_ace_network/Admin/AprooveCompany.dart';
import 'package:apptitude_ace_network/Screens/Company/CompanyHome.dart';
import 'package:apptitude_ace_network/Screens/Student/StudentHome.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:apptitude_ace_network/login/QuestionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Auth {
  static Future<void> companySignup(
      String companyName,
      String email,
      String password,
      File companyLogo,
      File doc,
      BuildContext context,
      Function loader) async {
    try {
      loader(true);
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String currentfileName1 = doc.path.split(Platform.pathSeparator).last;
      String currentfileName2 =
          companyLogo.path.split(Platform.pathSeparator).last;

      UploadTask uploadTask1 =
          bucket.ref().child("Documents").child(currentfileName1).putFile(doc);
      TaskSnapshot taskSnapshot1 = await uploadTask1;
      String downloadUrl1 = await taskSnapshot1.ref.getDownloadURL();

      UploadTask uploadTask2 = bucket
          .ref()
          .child("Company Logos")
          .child(currentfileName2)
          .putFile(companyLogo);
      TaskSnapshot taskSnapshot2 = await uploadTask2;
      String downloadUrl2 = await taskSnapshot2.ref.getDownloadURL();

      companyRequests.add({
        "name": companyName,
        "companyLogo": downloadUrl2,
        "email": email,
        "documentUrl": downloadUrl1,
        "isVerified": false,
        "token": token,
      });

      company.add({
        "name": companyName,
        "companyLogo": downloadUrl2,
        "email": email,
        "documentUrl": downloadUrl1,
        "isVerified": false,
        "token": token,
      });
      loader(false);
      showSuccess(context,
          "User Created SuccessFully !!\nYou Will be Notified When Verified");
    } on FirebaseAuthException catch (e) {
      showFailure(context, e.code);
      loader(false);
      print(e.code);
    } on FirebaseException catch (e) {
      showFailure(context, e.code);
      loader(false);
    } on Exception catch (e) {
      showFailure(context, e.toString());
      loader(false);
    }
  }

  static Future<void> studentSignup(
      String name,
      String email,
      String phone,
      String collageName,
      String password,
      BuildContext context,
      Function load) async {
    try {
      load(true);
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      student.add({
        "name": name,
        "email": email,
        "phone": phone,
        "collage": collageName,
        "token": token,
      });
      showSuccess(context, "User Created SuccessFully !!");
      load(false);
    } on FirebaseAuthException catch (e) {
      showFailure(context, e.code);
      load(false);
      print(e.code);
    } on Exception catch (e) {
      showFailure(context, e.toString());
      load(false);
    }
  }

  static void studentLogin(
      String email, String password, BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    student.where("email", isEqualTo: email).get().then((snap) async {
      if (snap.size != 0) {
        try {
          await auth.signInWithEmailAndPassword(
              email: email, password: password);
          user = auth.currentUser;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const StudentHome()),
              (route) => false);
          await student.where("email", isEqualTo: email).get().then((value) {
            var data = value.docs.first.data() as Map<String, dynamic>;
            if (data['token'] == token) {
            } else {
              String id = value.docs.first.id;
              student.doc(id).update({"token": token});
            }
          });
          user = auth.currentUser;
        } on FirebaseAuthException catch (e) {
          showFailure(context, e.code);
        }
      } else {
        showFailure(context, "User Not Found");
      }
    });
  }

  static void companyLogin(
      String email, String password, BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    company.where("email", isEqualTo: email).get().then((snap) async {
      if (snap.size != 0) {
        try {
          await auth.signInWithEmailAndPassword(
              email: email, password: password);
          await company.where("email", isEqualTo: email).get().then((value) {
            var data = value.docs.first.data() as Map<String, dynamic>;
            if (data['token'] == token) {
            } else {
              String id = value.docs.first.id;
              company.doc(id).update({"token": token});
            }
          });
          user = auth.currentUser;
          if (email == "admin123@gmail.com") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const ApproveRequests()),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const CompanyHome()),
                (route) => false);
          }
        } on FirebaseAuthException catch (e) {
          showFailure(context, e.code);
        }
      } else {
        showFailure(context, "User Not Found");
      }
    });
  }

  static void logout(BuildContext context) {
    auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const QuestionPage()),
        (route) => false);
    user = null;
  }

  // static Future<void> deleteAccount(String id, String email) async {
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: "admin123@gmail.com",
  //     password: 'Admin@123',
  //   );
  //   await userCredential.user!.delete();
  // }
}
