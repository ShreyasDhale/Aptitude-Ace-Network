import 'package:apptitude_ace_network/Screens/Student/OnlineTestPage.dart';
import 'package:apptitude_ace_network/Screens/Student/StudentHome.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/CompanyBranding.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PassKeyVerify extends StatelessWidget {
  final Map<String, dynamic> details;
  PassKeyVerify({super.key, required this.details});

  var passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter Pass Key",
          style: style,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: CachedNetworkImage(imageUrl: details['companyLogo'])),
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: details['subjectLogo'],
                width: 60,
                height: 60,
              ),
              title: Text("Enter Pass Key for ${details['subject']} test"),
            ),
            customTextfield(
                controller: passController,
                label: "Enter Pass key Provided",
                multiLine: false,
                leading: const Icon(Icons.password)),
            const SizedBox(
              height: 20,
            ),
            customButton(
                text: "Verify",
                onTap: () {
                  if (passController.text.trim() == details['passkey']) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotesToAttempt(
                                  details: details,
                                )),
                        (route) => false);
                    showSuccess(context, "Verified !!");
                  } else {
                    showFailure(context, "Incorrect Key Entered");
                  }
                },
                width: 200,
                height: 50,
                bgColor: Colors.deepPurple,
                borderRadius: 5)
          ],
        ),
      ),
    );
  }
}

class NotesToAttempt extends StatefulWidget {
  final Map<String, dynamic> details;
  const NotesToAttempt({super.key, required this.details});

  @override
  State<NotesToAttempt> createState() => _NotesToAttemptState();
}

class _NotesToAttemptState extends State<NotesToAttempt> {
  bool isAgreed = false;
  List<Map<String, dynamic>> questionsList = [];

  @override
  initState() {
    super.initState();
    getQuestions();
  }

  Future<void> getQuestions() async {
    List<Map<String, dynamic>> list = [];
    QuerySnapshot data = await question
        .where("subject", isEqualTo: widget.details['subject'])
        .limit(int.parse(widget.details['numberOfQuestions']))
        .get();
    for (var doc in data.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      list.add(data);
    }
    setState(() {
      questionsList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note The Below Points",
          style: style,
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CachedNetworkImage(imageUrl: widget.details['companyLogo']),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow.shade100),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CompanyBranding(imageName: null),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ",
                          style: style.copyWith(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "This is test for ${widget.details['subject']} subject",
                          style: style.copyWith(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ",
                          style: style.copyWith(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            "The test is timed. You have ${widget.details['duration']} minutes to complete the test. Please keep an eye on the clock and manage your time accordingly",
                            style: style.copyWith(
                                fontSize: 17,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ",
                          style: style.copyWith(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            "The test consists of multiple choice",
                            style: style.copyWith(
                                fontSize: 17,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ",
                          style: style.copyWith(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            "Do not consult any external help (such as other developers, online forums, etc.).",
                            style: style.copyWith(
                                fontSize: 17,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ",
                          style: style.copyWith(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            " Complete the test to the best of your ability and do not engage in dishonest practices.",
                            style: style.copyWith(
                                fontSize: 17,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ",
                          style: style.copyWith(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            " Switching screens in Between test will not be tolerated and the test will be auto submited",
                            style: style.copyWith(
                                fontSize: 17,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isAgreed,
                          onChanged: (value) {
                            setState(() {
                              isAgreed = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isAgreed = !isAgreed;
                              });
                            },
                            child: Text(
                              "I Agree the above conditions and will obey the rules",
                              style: style.copyWith(fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customButton(
                    text: "Attempt",
                    onTap: () async {
                      if (isAgreed) {
                        Map<String, dynamic> currentUser = await student
                            .where("email", isEqualTo: user?.email)
                            .get()
                            .then((value) {
                          return value.docs.first.data()
                              as Map<String, dynamic>;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExamPage(
                                  testDetails: widget.details,
                                  questions: questionsList,
                                  user: currentUser)),
                        );
                      } else {
                        showFailure(
                            context, "Please Agree before Starting test");
                      }
                    },
                    borderRadius: 5,
                    bgColor: Colors.green),
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentHome()),
                          (route) => false);
                    },
                    child: Text(
                      "Go back to Home",
                      style: style,
                    ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
