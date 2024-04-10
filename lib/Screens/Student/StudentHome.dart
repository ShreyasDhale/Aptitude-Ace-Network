import 'package:apptitude_ace_network/Screens/inAppUpdate.dart';
import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/login/QuestionPage.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int currentIndex = 0;
  Map<String, dynamic> details = {};

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    var detail = await student
        .where("email", isEqualTo: user!.email)
        .get()
        .then((value) {
      return value.docs.first.data() as Map<String, dynamic>;
    });
    setState(() {
      details = detail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome,",
              style: style.copyWith(color: Colors.white),
            ),
            Text(
              "${details['name']}",
              style: style.copyWith(fontSize: 19, color: Colors.white),
            ),
          ],
        ),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 15.0, bottom: 9),
          //   child: CircleAvatar(),
          // ),
        ],
        backgroundColor: Colors.purple.shade300,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 90,
            ),
            ListTile(
              title: Text(
                "Update",
                style: style,
              ),
              leading: const Icon(Icons.update),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InAppUpdate()),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                "Logout",
                style: style,
              ),
              leading: const Icon(Icons.logout),
              onTap: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuestionPage()),
                    (route) => false);
              },
            )
          ],
        ),
      ),
      body: pages1[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: Colors.purple.shade300,
        fixedColor: Colors.white,
        selectedLabelStyle: style.copyWith(color: Colors.white),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: Colors.white,
              size: 30,
            ),
            label: "history",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
