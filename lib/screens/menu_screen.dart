import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/main.dart';
import 'package:save_food/models/user.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/screens/accepted_food_screen.dart';
import 'package:save_food/screens/login_screen.dart';
import 'package:save_food/screens/profile_screen.dart';
import 'package:save_food/utils/navigate.dart';
import 'package:save_food/utils/size_config.dart';
import 'package:save_food/widgets/curved_body_widget.dart';
import 'package:save_food/widgets/general_alert_dialog.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileData = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileCard(context, profileData),
              SizedBox(
                  height: SizeConfig.height *
                      4), // Added more spacing for a cleaner look
              _buildMenuOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  // Build profile card for the user with enhanced design
  Widget _buildProfileCard(BuildContext context, UserModel profileData) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.width * 4),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.height * 3),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(SizeConfig.height * 5),
                child: profileData.image == null
                    ? Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: SizeConfig.height * 10,
                      )
                    : Image.memory(
                        base64Decode(profileData.image!),
                        fit: BoxFit.cover,
                        height: SizeConfig.height * 10,
                        width: SizeConfig.height * 10,
                      ),
              ),
              SizedBox(height: SizeConfig.height * 2),
              Text(
                profileData.name ?? 'User',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              SizedBox(height: SizeConfig.height * 1),
              Text(
                profileData.phoneNumber,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: SizeConfig.height * 1),
              Text(
                profileData.email ?? 'Email Not Available',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: SizeConfig.height * 1.5),
              Text(
                profileData.isFoodDonor ? "Food Donor" : "NGO",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: profileData.isFoodDonor ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the list of menu options with enhanced styling
  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          context,
          icon: Icons.person,
          label: "Your Profile",
          widget: ProfileScreen(),
        ),
        SizedBox(height: SizeConfig.height * 2),
        _buildListTile(
          context,
          icon: Icons.history_outlined,
          label: "Accepted Foods",
          widget: AcceptedFoodScreen(),
        ),
        SizedBox(height: SizeConfig.height * 2),
        _buildListTile(
          context,
          icon: Icons.logout_outlined,
          label: "Logout",
          color: Colors.red,
          func: () async {
            GeneralAlertDialog().customLoadingDialog(context);
            final hasBiometric = await hasBiometrics();
            navigateAndRemoveAll(context, LoginScreen(hasBiometric));
          },
        ),
      ],
    );
  }

  // Build individual list tile with cleaner design
  Widget _buildListTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    Widget? widget,
    Color? color,
    Function? func,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.width * 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Theme.of(context).primaryColor),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: const Icon(Icons.arrow_right_outlined),
        onTap: () => func != null ? func() : navigate(context, widget!),
      ),
    );
  }
}
