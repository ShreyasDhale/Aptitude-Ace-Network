import 'package:apptitude_ace_network/Backend/Firebase/FirebaseHelper.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:apptitude_ace_network/models/QuestionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  TextEditingController questionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  FirebaseHelper fh = FirebaseHelper();

  bool loader1 = false;
  bool loader2 = false;

  List<String> options = ["a", "b", "c", "d"];
  List<String> subject = [];
  String selectedOption = "a";
  String selectedSubject = "";
  int count = 0;

  @override
  void initState() {
    super.initState();
    fh.updateCount(getCount);
    getSubjects();
  }

  void getSubjects() async {
    List<String> sub = await fh.getSubjects();

    setState(() {
      subject = sub;
      selectedSubject = sub.first;
    });
  }

  void getCount(int cnt) {
    setState(() {
      count = cnt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Questions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1), color: Colors.yellow.shade200),
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Question Count : ",
                        style: GoogleFonts.stylish(
                            fontSize: 30, color: Colors.red),
                      ),
                      StreamBuilder(
                          stream: question
                              .where("subject", isEqualTo: selectedSubject)
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Text(
                                snapshot.data!.docs.length.toString(),
                                style: GoogleFonts.stylish(
                                    fontSize: 30, color: Colors.red),
                              );
                            } else {
                              return Text(
                                '0',
                                style: GoogleFonts.stylish(
                                    fontSize: 30, color: Colors.red),
                              );
                            }
                          }))
                    ],
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                ],
              ),
              customTextfield(
                  controller: questionController,
                  label: "Enter Question With Options"),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      height: 56,
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: selectedOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption = newValue!;
                          });
                        },
                        underline: Container(),
                        items: options
                            .map<DropdownMenuItem<String>>((String value) {
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
                    width: 10,
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      height: 56,
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: selectedSubject,
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSubject = newValue!;
                          });
                        },
                        items: subject
                            .map<DropdownMenuItem<String>>((String value) {
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
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              customTextfield(
                  controller: descriptionController,
                  label: "Enter Description (Optional)"),
              const SizedBox(
                height: 10,
              ),
              customButton(
                  text: "Add Questions",
                  loader: loader1,
                  onTap: () {
                    print(questionController.text);
                    String str = questionController.text;
                    List<String> data = str.split("\n");
                    data.add(selectedOption);
                    data.add(selectedSubject);
                    data.add("");
                    print(data);
                    if (data.isNotEmpty && data.length == 8) {
                      setState(() {
                        loader1 = true;
                      });
                      Question que = Question.listToQuestion(data);
                      fh.uploadQuestion(que, context);
                      showSuccess(context, "Question Uploaded !!");
                      setState(() {
                        questionController.text = "";
                        descriptionController.text = "";
                        loader1 = false;
                      });
                    } else {
                      showFailure(context, "Please Enter all Details");
                    }
                  }),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: Text(
                  "Add Subject",
                  style: GoogleFonts.stylish(fontSize: 30, color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customTextfield(
                  controller: subjectController,
                  label: "Enter Name Of Subject To Add"),
              const SizedBox(
                height: 10,
              ),
              customButton(
                  text: "Add Subject",
                  loader: loader2,
                  onTap: () async {
                    setState(() {
                      loader2 = true;
                    });
                    await fh.addSubject(subjectController.text.trim(), context);
                    getSubjects();
                    setState(() {
                      loader2 = false;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
