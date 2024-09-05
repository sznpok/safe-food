import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_food/screens/chat_room.dart';
import 'package:save_food/screens/chat_user_screen.dart';
import 'package:save_food/screens/home_screen.dart';
import 'package:save_food/screens/menu_screen.dart';
import 'package:save_food/screens/food_post_screen.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final profileData = Provider.of<UserProvider>(context).user;

    // Define the screens list based on the user's profile
    final List<Widget> screens = [
      const HomeScreen(),
      if (profileData.isFoodDonor) FoodPostScreen(),
      const ChatUsersScreen(),
      const MenuScreen(),
    ];

    return Scaffold(
      body: screens[index], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newIndex) {
          // Check if the selected index is valid
          if (newIndex < screens.length) {
            setState(() {
              index = newIndex;
            });
          } else if (profileData.isFoodDonor && newIndex == 1) {
            // Navigate to the FoodPostScreen if "Donate" is tapped and the user is a food donor
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodPostScreen(),
              ),
            );
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black, // Softer color for unselected items
        iconSize: 28, // Slightly larger icons
        backgroundColor:
            Theme.of(context).primaryColor, // Custom background color
        elevation: 10, // Add some elevation to the navigation bar
        type:
            BottomNavigationBarType.fixed, // Ensure items are always displayed
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          if (profileData.isFoodDonor)
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.volunteer_activism,
              ),
              label: 'Donate',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
