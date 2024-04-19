import 'package:apptitude_ace_network/Backend/Firebase/FirebaseHelper.dart';
import 'package:apptitude_ace_network/Screens/Student/NoteToAttempt.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  var searchController = TextEditingController();
  List<Map<String, dynamic>> companies = [];

  void addCompany(int index, String id) async {
    var fh = FirebaseHelper();
    Map<String, dynamic> company = await fh.getCompanyDetails(id);
    setState(() {
      companies.add(company);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: StreamBuilder(
        stream: test.snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active &&
              snapshot.data != null) {
            return Column(
              children: [
                customTextfield(
                    controller: searchController,
                    borderColor: Colors.transparent,
                    fillColor: Colors.yellow.shade50,
                    label: "Enter Keyword",
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.grey,
                        )),
                    leading: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var test = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          int marks = int.parse(test['marks/que']) *
                              int.parse(test['numberOfQuestions']);
                          return Column(
                            children: [
                              Card(
                                elevation: 5,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "Test By ${test['companyName']}",
                                        style: style,
                                      ),
                                      leading: CachedNetworkImage(
                                        imageUrl: test['companyLogo'],
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                    ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Subject : ${test['subject']}",
                                            style: style,
                                          ),
                                          Text(
                                            "Duration : ${test['duration']} Minutes",
                                            style: style,
                                          ),
                                          Text(
                                            "Total marks : $marks",
                                            style: style,
                                          ),
                                          Text(
                                            "Negative Marks : - ${test['negatve/Marks']}",
                                            style: style,
                                          ),
                                        ],
                                      ),
                                      leading: CachedNetworkImage(
                                        imageUrl: test['subjectLogo'],
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.lock),
                                          Text(
                                            "Passkey Protected",
                                            style: style.copyWith(
                                                color: Colors.red),
                                          ),
                                          customButton(
                                              text: "Attempt",
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PassKeyVerify(
                                                              details: test,
                                                            )));
                                              },
                                              height: 40,
                                              width: 100,
                                              bgColor: Colors.orange,
                                              borderRadius: 5),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }))
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Container();
          } else {
            return const Text("No Data");
          }
        }),
      ),
    );
  }
}
