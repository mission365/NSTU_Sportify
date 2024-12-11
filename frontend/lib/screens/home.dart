import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthManager.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authManager = Provider.of<AuthManager>(context);
    final username = authManager.username;
    final isLoggedIn = authManager.isLoggedIn;
    final isAdmin = authManager.isAdmin;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bgtsports.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar with username
                CustomAppBar(
                  username: username,
                  isLoggedIn: isLoggedIn,
                  isAdmin: isAdmin,
                ),
                // Body Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Body(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String? username;
  final bool isLoggedIn;
  final bool isAdmin;

  const CustomAppBar({
    super.key,
    this.username,
    required this.isLoggedIn,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 80.0),
              child: Text(
                "NSTU Sportify",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                MenuItem(title: "Home", press: () {}),
                MenuItem(title: "Notice", press: () {
                  Navigator.pushNamed(context, '/notices');
                }),
                MenuItem(title: "Events", press: () {
                  Navigator.pushNamed(context, '/events');
                }),
                MenuItem(
                  title: "Representatives",
                  press: () {
                    Navigator.pushNamed(context, '/representatives');
                  },
                ),
                MenuItem(title: "Participants", press: () {
                  Navigator.pushNamed(context, '/players');
                }),
                if (isLoggedIn)
                  MenuItem(
                    title: isAdmin ? "Admin Dashboard" : "Dashboard",
                    press: () {
                      Navigator.pushNamed(
                        context,
                        isAdmin ? '/admin-dashboard' : '/representativesdashboard',
                      );
                    },
                  ),
                if (!isLoggedIn)
                  MenuItem(title: "Login", press: () {
                    Navigator.pushNamed(context, '/login');
                  }),
                if (isLoggedIn)
                  MenuItem(title: "Logout", press: () {
                    Provider.of<AuthManager>(context, listen: false).logout();
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// MenuItem Widget
class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback press;
  const MenuItem({super.key, required this.title, required this.press});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Body Widget
class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Text(
              "First ever \nSports Website \nat NSTU",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 2,
            color: Colors.green,
            indent: 20,
            endIndent: 650,
          ),
          Row(
            children: [
              // Score Button
              CustomButton(label: "Past", onTap: () {
                Navigator.pushNamed(context, '/winners');
              }),
              CustomButton(label: "Result", onTap: () {
                Navigator.pushNamed(context, '/results');
              }),
              CustomButton(label: "Schedule", onTap: () {
                Navigator.pushNamed(context, '/schedule');
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// CustomButton Widget
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CustomButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0x777798B4),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
