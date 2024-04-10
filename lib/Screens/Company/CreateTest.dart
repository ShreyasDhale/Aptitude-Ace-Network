import 'package:apptitude_ace_network/Backend/Firebase/FirebaseHelper.dart';
import 'package:apptitude_ace_network/Backend/Firebase/FirebaseMessaging.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateTest extends StatefulWidget {
  final String userId;
  final String name;
  const CreateTest({super.key, required this.userId, required this.name});

  @override
  State<CreateTest> createState() => _CreateTestState();
}

class _CreateTestState extends State<CreateTest> {
  List<String> Subjects = [];
  String selectedSubject = "";
  Duration? duration;

  TextEditingController numberController = TextEditingController();
  TextEditingController markController = TextEditingController();
  TextEditingController negativeController = TextEditingController();
  TextEditingController passKeyController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    getSubjects();
    super.initState();
  }

  void getSubjects() async {
    QuerySnapshot snap = await subject.get();
    List<String> subjects = [];
    for (var doc in snap.docs) {
      var data = doc.data() as Map<String, dynamic>;
      subjects.add(data['name']);
    }
    setState(() {
      Subjects = [];
      Subjects = subjects;
      selectedSubject = Subjects.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create test",
          style: style,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Online Aptitude Form",
                style: style.copyWith(fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Select duration",
              style: style.copyWith(fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: customTextfield(
                    controller: durationController,
                    label: "Pick Duration",
                    enabled: false,
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: TextButton(
                        onPressed: () async {
                          final resultingDuration = await showDurationPicker(
                            context: context,
                            initialTime: const Duration(
                              minutes: 30,
                              hours: 1,
                              seconds: 00,
                            ),
                          );
                          if (resultingDuration != null) {
                            var temp = resultingDuration;
                            var arr = temp.toString().split(":");
                            String min = arr[1];
                            String hr = arr[0];
                            setState(() {
                              duration = resultingDuration;
                              durationController.text = "$hr hrs : $min min";
                            });
                          }
                        },
                        child: Text(
                          "Set Timer",
                          style: style,
                        )))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Select Subject",
              style: style.copyWith(fontSize: 18),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 65,
              child: Center(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: selectedSubject,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubject = newValue!;
                    });
                  },
                  items: Subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Enter No. of Questions",
              style: style.copyWith(fontSize: 18),
            ),
            customTextfield(
                controller: numberController,
                label: "50",
                type: TextInputType.number),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Marks / Question",
                      style: style.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: customTextfield(
                          controller: markController,
                          label: "2",
                          type: TextInputType.number),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Netagive Marks",
                      style: style.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: customTextfield(
                          controller: negativeController,
                          label: "0.5",
                          type: TextInputType.number),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Create Passkey",
              style: style.copyWith(fontSize: 18),
            ),
            customTextfield(
                controller: passKeyController,
                label: "Passkey@123",
                trailing: TextButton(
                    onPressed: () {
                      setState(() {
                        passKeyController.text = const Uuid().v1();
                      });
                    },
                    child: Text(
                      "Generate",
                      style: style,
                    ))),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Note : Passkey is required to attaind the test so you will have to share it with students",
              style: style.copyWith(color: Colors.red),
            ),
            const SizedBox(
              height: 30,
            ),
            customButton(text: "Create Test", onTap: saveTest)
          ],
        ),
      ),
    );
  }

  Future<void> saveTest() async {
    if (duration != null &&
        numberController.text.trim() != "" &&
        markController.text.trim() != "" &&
        negativeController.text.trim() != "" &&
        passKeyController.text.trim() != "") {
      String id;
      String name;
      FirebaseHelper fh = FirebaseHelper();
      if (widget.userId != "") {
        id = widget.userId;
        name = widget.name;
      } else {
        id = await company
            .where("email", isEqualTo: user!.email)
            .get()
            .then((value) => value.docs.first.id);
        name = await company
            .where("email", isEqualTo: user!.email)
            .get()
            .then((value) {
          Map<String, dynamic> data =
              value.docs.first.data() as Map<String, dynamic>;
          return data['name'];
        });
      }
      int count = int.parse(numberController.text);
      if (!await fh.canCreate(count, selectedSubject)) {
        await test.add({
          "userId": id,
          "duration": duration!.inMinutes,
          "subject": selectedSubject,
          "numberOfQuestions": numberController.text.trim(),
          "marks/que": markController.text.trim(),
          "negatve/Marks": negativeController.text.trim(),
          "passkey": passKeyController.text.trim(),
          "createdAt": DateTime.now()
        });
        Messaging.notifyAllUsers("New Test !!",
            "New Test for $selectedSubject is created by $name", context);
        setState(() {
          numberController.text = "";
          markController.text = "";
          negativeController.text = "";
          passKeyController.text = "";
          durationController.text = "";
        });
        showSuccess(context, "Test Created Successfully");
      } else {
        showFailure(context, "Cant Create Test");
      }
    } else {
      showFailure(context, "Please Enter All Details");
    }
  }
}
