import 'dart:io';

import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googledrivehandler/googledrivehandler.dart';
import 'package:open_file/open_file.dart';

class ReleaseUpdate extends StatefulWidget {
  const ReleaseUpdate({super.key});

  @override
  State<ReleaseUpdate> createState() => _ReleaseUpdateState();
}

class _ReleaseUpdateState extends State<ReleaseUpdate> {
  bool loader = false;
  TextEditingController versionController = TextEditingController();
  String fileName = "No File Picked";
  File? apk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Update apk",
          style: style,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            StreamBuilder(
                stream: appLink.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    return Text(
                      "Current Version : ${data['currentVersion']}",
                      style: style.copyWith(fontSize: 20),
                    );
                  } else {
                    return Text(
                      "No Data",
                      style: style,
                    );
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            customTextfield(
                controller: versionController,
                label: "Enter new version",
                type: TextInputType.number,
                leading: const Icon(Icons.app_blocking)),
            const SizedBox(
              height: 10,
            ),
            Text(
              fileName,
              style: style,
            ),
            const SizedBox(
              height: 30,
            ),
            customButton(
                text: "pick file",
                bgColor: Colors.red,
                borderRadius: 10,
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ["apk"]);
                  if (result != null) {
                    File convertedFile = File(result.files.first.path!);
                    setState(() {
                      apk = convertedFile;
                      fileName = convertedFile.path.split("/").last;
                    });
                  } else {
                    return;
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            customButton(
                text: "Release",
                bgColor: Colors.blue,
                borderRadius: 10,
                loader: loader,
                onTap: update),
          ],
        ),
      ),
    );
  }

  Future<void> update() async {
    showMessage(context, "Work in Progress");
    GoogleDriveHandler()
        .setAPIKey(apiKey: "key=AIzaSyAzPBWQSEEPSiMoelq1IGqrBm2wpO6qjrw");
    try {
      File? myFile =
          await GoogleDriveHandler().getFileFromGoogleDrive(context: context);
      if (myFile != null) {
        print(myFile.path);
        OpenFile.open(myFile.path);
      } else {
        //Discard...
      }
    } on PlatformException catch (e) {
      showMessage(context, e.message!);
      print(e.stacktrace);
      print(e.message);
    }
    // if (apk != null && versionController.text.trim() != "") {
    //   setState(() {
    //     loader = true;
    //   });
    //   try {
    //     FirebaseHelper fh = FirebaseHelper();
    //     await fh.updateVersion(apk!, versionController.text.trim());
    //     setState(() {
    //       loader = true;
    //     });
    //   } on Exception catch (e) {
    //     showFailure(context, e.toString());
    //     setState(() {
    //       loader = true;
    //     });
    //   }
    // } else {
    //   showFailure(context, "Please Pick Apk first and enter new version");
    // }
  }

  Future<String> getCurrentVersion() async {
    String version = "";
    await appLink.get().then((value) {
      var data = value.data() as Map<String, dynamic>;
      setState(() {
        version = data["currentVersion"];
      });
    });
    return version;
  }
}
