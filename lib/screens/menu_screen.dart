import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_food/constants/constants.dart';
import 'package:save_food/main.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/screens/accepted_food_screen.dart';
import 'package:save_food/screens/chat_user_screen.dart';
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
    final profileData = Provider.of<UserProvider>(
      context,
    ).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
      ),
      body: CurvedBodyWidget(
          widget: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Padding(
                  padding: basePadding,
                  child: Column(
                    children: [
                      Hero(
                        tag: "image-url",
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height * 8),
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
                      ),
                      SizedBox(
                        height: SizeConfig.height,
                      ),
                      Text(
                        profileData.name!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
                      ),
                      Text(profileData.phoneNumber),
                      SizedBox(
                        height: SizeConfig.height / 2,
                      ),
                      Text(profileData.email!),
                      Text(
                        profileData.isFoodDonor ? "Food Donor" : "NGO",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: profileData.isFoodDonor
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.height * 3,
            ),
            buildListTile(
              context,
              icon: Icons.person,
              label: "Your Profile",
              widget: ProfileScreen(),
            ),
            SizedBox(
              height: SizeConfig.height * 2,
            ),
            buildListTile(
              context,
              icon: Icons.history_outlined,
              label: "Accepted Foods",
              widget: AcceptedFoodScreen(),
            ),
            SizedBox(
              height: SizeConfig.height * 2,
            ),
            buildListTile(
              context,
              icon: Icons.chat,
              label: "Chat Room",
              color: Colors.blue,
              widget: const ChatUsersScreen(),
            ),
            SizedBox(
              height: SizeConfig.height * 2,
            ),

            buildListTile(
              context,
              icon: Icons.logout_outlined,
              label: "Logout",
              color: Colors.red,
              func: () async {
                GeneralAlertDialog().customLoadingDialog(context);
                final hasBiometric = await hasBiometrics();
                navigateAndRemoveAll(
                  context,
                  LoginScreen(hasBiometric),
                );
              },
            ),
            // SizedBox(
            //   height: SizeConfig.height * 3,
            // ),
            // buildListTile(
            //   context,
            //   label: "Your Profile",
            //   widget: ProfileScreen(),
            // ),
          ],
        ),
      )),
    );
  }

  Widget buildListTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    Widget? widget,
    Color? color,
    Function? func,
  }) {
    return Card(
      child: ListTile(
        selectedColor: color,
        selected: color != null ? true : false,
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(
          Icons.arrow_right_outlined,
        ),
        onTap: () => func != null ? func() : navigate(context, widget!),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:save_food/constants/constants.dart';
// import 'package:save_food/main.dart';
// import 'package:save_food/models/user.dart';
// import 'package:save_food/providers/user_provider.dart';
// import 'package:save_food/screens/accepted_food_screen.dart';
// import 'package:save_food/screens/login_screen.dart';
// import 'package:save_food/screens/profile_screen.dart';
// import 'package:save_food/utils/navigate.dart';
// import 'package:save_food/utils/size_config.dart';
// import 'package:save_food/widgets/curved_body_widget.dart';
// import 'package:save_food/widgets/general_alert_dialog.dart';
// import 'package:provider/provider.dart';

// class MenuScreen extends StatelessWidget {
//   const MenuScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final profileData = Provider.of<UserProvider>(context).user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Menu"),
//         centerTitle: true, // Center the title
//       ),
//       body: CurvedBodyWidget(
//         widget: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 5),
//           child: Column(
//             children: [
//               _buildProfileCard(context, profileData),
//               SizedBox(height: SizeConfig.height * 3),
//               _buildMenuOption(
//                 context,
//                 icon: Icons.person,
//                 label: "Your Profile",
//                 destination:  ProfileScreen(),
//               ),
//               SizedBox(height: SizeConfig.height * 2),
//               _buildMenuOption(
//                 context,
//                 icon: Icons.history_outlined,
//                 label: "Accepted Foods",
//                 destination: AcceptedFoodScreen(),
//               ),
//               SizedBox(height: SizeConfig.height * 2),
//               _buildMenuOption(
//                 context,
//                 icon: Icons.logout_outlined,
//                 label: "Logout",
//                 color: Colors.red,
//                 action: () async {
//                   GeneralAlertDialog().customLoadingDialog(context);
//                   final hasBiometric = await hasBiometrics();
//                   navigateAndRemoveAll(
//                     context,
//                     LoginScreen(hasBiometric),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard(BuildContext context, User profileData) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: SizeConfig.height * 8,
//               backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//               backgroundImage: profileData.image != null
//                   ? MemoryImage(base64Decode(profileData.image!))
//                   : null,
//               child: profileData.image == null
//                   ? Icon(
//                       Icons.person,
//                       color: Theme.of(context).primaryColor,
//                       size: SizeConfig.height * 10,
//                     )
//                   : null,
//             ),
//             SizedBox(height: SizeConfig.height),
//             Text(
//               profileData.name ?? "User Name",
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: SizeConfig.height / 2),
//             Text(
//               profileData.phoneNumber,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             SizedBox(height: SizeConfig.height / 2),
//             Text(
//               profileData.email ?? "user@example.com",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuOption(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     Widget? destination,
//     Color? color,
//     Function? action,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Icon(icon, color: color ?? Theme.of(context).primaryColor),
//         title: Text(label),
//         trailing: const Icon(Icons.arrow_right_outlined),
//         onTap: () {
//           if (action != null) {
//             action();
//           } else if (destination != null) {
//             navigate(context, destination);
//           }
//         },
//       ),
//     );
//   }
// }
