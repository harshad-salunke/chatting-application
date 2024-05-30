import 'package:chat_application/screens/mainSubScreens/group_chat_screen.dart';
import 'package:chat_application/screens/mainSubScreens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'mainSubScreens/home_screen.dart';

class MainScreen extends StatefulWidget {
  static final String routePath = "/mainscreen";
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {

    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: [
          HomeScreen(),
          GroupChatScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: GNav(
            gap: 8, // the tab button gap between icon and text
            activeColor: Colors.white, // selected icon and text color
            iconSize: 24, // tab button icon size
            tabBackgroundColor: Colors.blue.shade400, // selected tab background color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Adjusted padding
            selectedIndex: currentPage,
            onTabChange: (index) {
              pageController.jumpToPage(index);
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.group_outlined,
                text: 'Groups',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
