import 'dart:io';

import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppUpdate extends StatefulWidget {
  const InAppUpdate({super.key});

  @override
  State<InAppUpdate> createState() => _InAppUpdateState();
}

class _InAppUpdateState extends State<InAppUpdate> {
  String currentVersion = "";
  String latestVersion = "";
  String link = "";

  @override
  void initState() {
    super.initState();
    getUpdateLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update",
          style: style,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            StreamBuilder(
                stream: appLink.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var doc = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Current Version : ",
                              style: style,
                            ),
                            Text(
                              doc["currentVersion"],
                              style: style,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Available Version : ",
                              style: style,
                            ),
                            Text(
                              doc["latestVersion"],
                              style: style,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        doc["currentVersion"] == doc["latestVersion"]
                            ? Text(
                                "You are already on the latest version",
                                style: style.copyWith(
                                    fontWeight: FontWeight.w800, fontSize: 17),
                              )
                            : customButton(
                                text: "Update app",
                                bgColor: Colors.green,
                                borderRadius: 10,
                                onTap: update),
                      ],
                    );
                  } else {
                    return Text("No data");
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<void> update() async {
    Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    exit(0);
  }

  Future<void> getUpdateLink() async {
    DocumentSnapshot snap = await appLink.get();
    var data = snap.data() as Map<String, dynamic>;
    setState(() {
      currentVersion = data["currentVersion"];
      latestVersion = data["latestVersion"];
      link = data["link"];
    });
  }
}
