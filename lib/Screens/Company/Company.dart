import 'package:apptitude_ace_network/Backend/Firebase/FirebaseHelper.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Company extends StatefulWidget {
  const Company({super.key});

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  String id = "";

  @override
  void initState() {
    super.initState();
    getId();
  }

  Future<void> getId() async {
    String str = await FirebaseHelper.getId();
    setState(() {
      id = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
            stream: test.where("userId", isEqualTo: id).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> test = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      int number = int.parse(test['numberOfQuestions']);
                      int marksper = int.parse(test['marks/que']);
                      int marks = number * marksper;
                      Timestamp createdAt = test['createdAt'];
                      return Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Test : ${index + 1}",
                                            style: style.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Date : ${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}",
                                            style: style.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        color: Colors.black,
                                        height: 1,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Subject : ${test['subject']}",
                                        style: style.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Duration : ${test['duration']} Min",
                                        style: style,
                                      ),
                                      Text(
                                        "Max Marks : $marks",
                                        style: style,
                                      ),
                                      Text(
                                        "Negative Marks : -${test['negatve/Marks']}",
                                        style: style,
                                      ),
                                      Text(
                                        (test['attempts'] == null ||
                                                test['attempts'] == "")
                                            ? "Total Attempts : 0"
                                            : "Total Attempts : ${test['attempts']}",
                                        style: style,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        color: Colors.black,
                                        height: 1,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: customButton(
                                                text: "Edit",
                                                bgColor: Colors.orange,
                                                onTap: () {
                                                  showMessage(context,
                                                      "Work in Progress");
                                                },
                                                height: 40,
                                                borderRadius: 4),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: customButton(
                                                text: "Open",
                                                onTap: () {
                                                  showMessage(context,
                                                      "Work in Progress");
                                                },
                                                height: 40,
                                                borderRadius: 4),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              } else {
                return Text(
                  "No Data",
                  style: style,
                );
              }
            }),
      ),
    );
  }
}
