import 'package:apptitude_ace_network/Screens/Company/AddQuestions.dart';
import 'package:apptitude_ace_network/Screens/Company/CreateTest.dart';
import 'package:apptitude_ace_network/Screens/inAppUpdate.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/FormWidgets.dart';
import 'package:apptitude_ace_network/login/Auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CompanyHome> {
  @override
  void initState() {
    super.initState();
    getCompanyDetails();
  }

  Map<String, dynamic> details = {};
  String id = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          title: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CachedNetworkImage(
              imageUrl: (details['companyLogo'] != null)
                  ? details['companyLogo']
                  : "https://placeholderlogo.com/img/placeholder-logo-1.png",
              width: 80,
              height: 70,
            ),
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Welcome",
                      style: style.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${details['email']}",
                        style: style,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey.shade200,
          unselectedItemColor: Colors.black,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          selectedItemColor: Colors.black,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                CachedNetworkImage(
                  imageUrl: (details['companyLogo'] != null)
                      ? details['companyLogo']
                      : "https://placeholderlogo.com/img/placeholder-logo-1.png",
                  width: 80,
                  height: 70,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    "${details['email']}",
                    style: style,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  tileColor: Colors.grey.shade300,
                  title: Text(
                    "Add Questions",
                    style: style,
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const AddQuestion()))),
                  leading: const Icon(Icons.question_mark_rounded),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  tileColor: Colors.grey.shade300,
                  title: Text(
                    "Check for update",
                    style: style,
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const InAppUpdate()))),
                  leading: const Icon(Icons.update),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  tileColor: Colors.grey.shade300,
                  title: Text(
                    "Logout",
                    style: style,
                  ),
                  onTap: () => Auth.logout(context),
                  leading: const Icon(Icons.person),
                  trailing: IconButton(
                      onPressed: () => Auth.logout(context),
                      icon: const Icon(Icons.logout)),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
            margin: const EdgeInsets.all(0),
            child: customButton(
                text: "+ Create Test",
                width: 150,
                height: 60,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateTest(
                                userId: id,
                                name: name,
                                details: details,
                              )));
                })));
  }

  bool changeScreen() {
    return false;
  }

  int currentIndex = 0;

  Future<void> getCompanyDetails() async {
    await company.where("email", isEqualTo: user?.email).get().then((value) {
      setState(() {
        details = value.docs.first.data() as Map<String, dynamic>;
        name = details['name'];
        id = value.docs.first.id;
      });
    });
  }
}
