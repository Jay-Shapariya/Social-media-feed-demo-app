import 'package:flutter/material.dart';
import 'package:social_media_feed_task/screen/home_screen.dart';
import 'package:social_media_feed_task/screen/profile_screen.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var curruntNavIndex = 0.obs;

    var navbarItem = [
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 26,
          ),
          label: "Home"),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 26,
          ),
          label: "Profile"),
    ];
    var navBody = [const HomeScreen(), const ProfileScreen()];
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: navBody.elementAt(curruntNavIndex.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: curruntNavIndex.value,
          items: navbarItem,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          selectedLabelStyle: const TextStyle(
              fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
          onTap: (value) {
            curruntNavIndex.value = value;
          },
        ),
      ),
    );
  }
}
