import 'package:apptitude_ace_network/Backend/Firebase/FirebaseMessaging.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:apptitude_ace_network/models/QuestionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseHelper {
  CollectionReference questions =
      FirebaseFirestore.instance.collection("Questions");
  CollectionReference subjects =
      FirebaseFirestore.instance.collection("Subjects");

  Future<void> uploadQuestion(Question question, BuildContext context) async {
    questions.add({
      "question": question.que,
      "a": question.a,
      "b": question.b,
      "c": question.c,
      "d": question.d,
      "correct": question.correct,
      "subject": question.subject,
      "desc": question.desc,
    });
  }

  Future<void> updateCount(Function updateCount) async {
    await questions.get().then((value) => updateCount(value.size));
  }

  Future<List<String>> getSubjects() async {
    QuerySnapshot snapshot = await subjects.get();
    List<String> subject = [];
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        subject.add(data['name'].toString());
      }
    }
    return subject;
  }

  Future<void> addSubject(String name, BuildContext context) async {
    if (await subjectExists(name)) {
      showFailure(context, "Subject Already Exists");
    } else {
      subjects.add({"name": name});
    }
  }

  Future<bool> subjectExists(String name) async {
    await subjects.where("name", isEqualTo: name).get().then((value) {
      if (value.size != 0) {
        return true;
      }
    });
    return false;
  }

  Future<void> verify(Map<String, dynamic> comp, BuildContext context) async {
    company.add(comp);
    await companyRequests
        .where("email", isEqualTo: comp['email'])
        .get()
        .then((value) {
      for (var doc in value.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Messaging.sendPushMessage(
            data['token'],
            "Congractulations ${data['email']}!!\n\tYour Company is verified. Now you can take tests",
            "Verified !!");
        String id = doc.id;
        companyRequests.doc(id).update({"isVerified": true});
      }
    });
    showSuccess(context, "Updated Successfully !");
  }
}
