import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  var searchController = TextEditingController();

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
                    borderColor: Colors.white,
                    fillColor: Colors.yellow.shade100,
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
                    ))
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
