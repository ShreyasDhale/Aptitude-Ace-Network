import 'dart:io';

import 'package:apptitude_ace_network/Admin/releaseNewApk.dart';
import 'package:apptitude_ace_network/Backend/Firebase/FirebaseHelper.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:apptitude_ace_network/login/QuestionPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ApproveRequests extends StatefulWidget {
  const ApproveRequests({super.key});

  @override
  State<ApproveRequests> createState() => _ApproveRequestsState();
}

class _ApproveRequestsState extends State<ApproveRequests> {
  int index = 0;
  FirebaseHelper fh = FirebaseHelper();

  List<Widget> pages = [
    AllRequests(),
    UnVerified(),
    Verified(),
    const ReleaseUpdate()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Company Requests",
          style: style.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuestionPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        selectedFontSize: 20,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.request_page), label: "All"),
          BottomNavigationBarItem(
              icon: Icon(Icons.device_unknown), label: "Unverified"),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user), label: "Verified"),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: "Release"),
        ],
      ),
    );
  }
}

class AllRequests extends StatelessWidget {
  AllRequests({
    super.key,
  });

  final FirebaseHelper fh = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: companyRequests.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> company =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Column(
                    children: [
                      Card(
                        elevation: 10,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //   width: 1,
                              // ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: company['companyLogo'],
                                  width: 80,
                                  height: 70,
                                ),
                                title: Text(
                                  company['name'],
                                  style: style.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  company['email'],
                                  style: style,
                                ),
                                trailing: company['isVerified']
                                    ? const Icon(
                                        Icons.verified_outlined,
                                        color: Colors.green,
                                      )
                                    : null,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: customButton(
                                        text: "View Document",
                                        onTap: () => download(
                                            company['documentUrl'], context),
                                        borderRadius: 10,
                                        width: 100),
                                  ),
                                  if (!company['isVerified'])
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  if (!company['isVerified'])
                                    Expanded(
                                      child: customButton(
                                          text: "Verify",
                                          onTap: () =>
                                              fh.verify(company, context),
                                          borderRadius: 10,
                                          width: 100),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  company['isVerified']
                                      ? Text(
                                          "Verified",
                                          style: style.copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w800),
                                        )
                                      : Text(
                                          "Not Verified",
                                          style: style.copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w800),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (snapshot.data!.docs.length - 1 == index)
                        const SizedBox(
                          height: 20,
                        )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No Requests Yett !!");
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else {
          print("Connection state is not active!");
          return const Center(
            child: Text(
              "No data !!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }
}

Future<void> download(String url, BuildContext context) async {
  Dio dio = Dio();
  Directory? downloadsDirectory = await getDownloadsDirectory();
  String fileName = path.basename(Uri.parse(url).path);

  String filePath = "${downloadsDirectory!.path}/$fileName";
  dio.download(url, filePath, onReceiveProgress: (receivedBytes, totalBytes) {
    // Progress callback (optional)
    print(
        'Received: ${receivedBytes / totalBytes * 100}% ($receivedBytes/$totalBytes)');
  });
  showSuccess(context, "Downloaded in $filePath");
}

class Verified extends StatelessWidget {
  Verified({
    super.key,
  });

  final FirebaseHelper fh = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: companyRequests.where("isVerified", isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> company =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: company['companyLogo'],
                                      width: 80,
                                      height: 70,
                                    ),
                                    title: Text(
                                      company['name'],
                                      style: style.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      company['email'],
                                      style: style,
                                    ),
                                    trailing: company['isVerified']
                                        ? const Icon(
                                            Icons.verified_outlined,
                                            color: Colors.green,
                                          )
                                        : null,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: customButton(
                                            text: "View Document",
                                            onTap: () => download(
                                                company['documentUrl'],
                                                context),
                                            borderRadius: 10,
                                            width: 100),
                                      ),
                                      if (!company['isVerified'])
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      if (!company['isVerified'])
                                        Expanded(
                                          child: customButton(
                                              text: "Verify",
                                              onTap: () =>
                                                  fh.verify(company, context),
                                              borderRadius: 10,
                                              width: 100),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      company['isVerified']
                                          ? Text(
                                              "Verified",
                                              style: style.copyWith(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          : Text(
                                              "Not Verified",
                                              style: style.copyWith(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (snapshot.data!.docs.length - 1 == index)
                        const SizedBox(
                          height: 20,
                        )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No Requests Yett !!");
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else {
          print("Connection state is not active!");
          return const Center(
            child: Text(
              "No data !!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }
}

class UnVerified extends StatelessWidget {
  UnVerified({
    super.key,
  });

  final FirebaseHelper fh = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: companyRequests.where("isVerified", isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> company =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Column(
                    children: [
                      Card(
                        elevation: 10,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: company['companyLogo'],
                                  width: 80,
                                  height: 70,
                                ),
                                title: Text(
                                  company['name'],
                                  style: style.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  company['email'],
                                  style: style,
                                ),
                                trailing: company['isVerified']
                                    ? const Icon(
                                        Icons.verified_outlined,
                                        color: Colors.green,
                                      )
                                    : null,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: customButton(
                                        text: "View Document",
                                        onTap: () => download(
                                            company['documentUrl'], context),
                                        borderRadius: 10,
                                        width: 100),
                                  ),
                                  if (!company['isVerified'])
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  if (!company['isVerified'])
                                    Expanded(
                                      child: customButton(
                                          text: "Verify",
                                          onTap: () =>
                                              fh.verify(company, context),
                                          borderRadius: 10,
                                          width: 100),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  company['isVerified']
                                      ? Text(
                                          "Verified",
                                          style: style.copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w800),
                                        )
                                      : Text(
                                          "Not Verified",
                                          style: style.copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w800),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (snapshot.data!.docs.length - 1 == index)
                        const SizedBox(
                          height: 20,
                        )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No Requests Yett !!");
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else {
          print("Connection state is not active!");
          return const Center(
            child: Text(
              "No data !!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }
}
