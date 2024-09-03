import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_food/screens/login_screen.dart';
import 'package:save_food/utils/navigate.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '/constants/constants.dart';
import '/providers/user_provider.dart';
import '/utils/firebase_helper.dart';
import '/utils/size_config.dart';
import '/utils/validation_mixin.dart';
import '/widgets/curved_body_widget.dart';
import '/widgets/general_alert_dialog.dart';
import '/widgets/general_text_field.dart';

class RegisterProfileScreen extends StatelessWidget {
  RegisterProfileScreen({
    Key? key,
    required this.uuid,
    required this.email,
  }) : super(key: key);

  final String uuid;
  final String email;

  // final String imageUrl;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final isFoodDonorController = TextEditingController();
  final panController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: CurvedBodyWidget(
          widget: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Hero(
              //   tag: "image-url",
              //   child: SizedBox(
              //     height: SizeConfig.height * 16,
              //     width: SizeConfig.height * 16,
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(SizeConfig.height * 8),
              //       child: profileData.image == null
              //           ? Icon(
              //               Icons.person,
              //               size: SizeConfig.height * 15,
              //             )
              //           : Image.memory(
              //               base64Decode(profileData.image!),
              //               fit: BoxFit.cover,
              //             ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              Text(
                "Fill your Information",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              GeneralTextField(
                title: "Name",
                controller: nameController,
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validate: (value) => ValidationMixin().validate(value!, "name"),
                onFieldSubmitted: (_) {},
              ),
              SizedBox(
                height: SizeConfig.height * 1.5,
              ),
              GeneralTextField(
                title: "Address",
                controller: addressController,
                textInputType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                validate: (value) =>
                    ValidationMixin().validate(value!, "address"),
                onFieldSubmitted: (_) {},
              ),
              SizedBox(
                height: SizeConfig.height * 1.5,
              ),
              GeneralTextField(
                title: "Phone Number",
                controller: phoneController,
                maxLength: 10,
                textInputType:
                    const TextInputType.numberWithOptions(decimal: false),
                textInputAction: TextInputAction.done,
                validate: (value) =>
                    ValidationMixin().validate(value!, "Phone Number"),
                onFieldSubmitted: (_) {},
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              IsFoodDonor(
                controller: isFoodDonorController,
                panController: panController,
              ),
              SizedBox(
                height: SizeConfig.height * 4,
              ),
              GeneralElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      print("hello");
                      final map =
                          Provider.of<UserProvider>(context, listen: false)
                              .createUser(
                        uuid: uuid,
                        email: email,
                        name: nameController.text,
                        address: addressController.text,
                        isFoodDonor: isFoodDonorController.text == "true",
                        phoneNumber: phoneController.text,
                        panNumber: panController.text.isEmpty
                            ? null
                            : panController.text,
                      );
                      print("hello");
                      await FirebaseHelper().addOrUpdateContent(
                        context,
                        collectionId: UserConstants.userCollection,
                        whereId: UserConstants.userId,
                        whereValue: uuid,
                        map: map,
                      );
                      final hasBiometric =
                          await LocalAuthentication().canCheckBiometrics;
                      navigateAndRemoveAll(context, LoginScreen(hasBiometric));
                    } catch (ex) {
                      GeneralAlertDialog()
                          .customAlertDialog(context, ex.toString());
                    }
                  }
                },
                title: "Save",
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> showBottomSheet(BuildContext context) async {
    final imagePicker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: basePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose a source",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(
              height: SizeConfig.height * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildChooseOptions(
                  context,
                  func: () async {
                    final xFile =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    if (xFile != null) {
                      final unit8list = await xFile.readAsBytes();
                      Provider.of<UserProvider>(context, listen: false)
                          .updateUserImage(base64Encode(unit8list));
                    }
                  },
                  iconData: Icons.camera_outlined,
                  label: "Camera",
                ),
                buildChooseOptions(
                  context,
                  func: () {},
                  iconData: Icons.collections_outlined,
                  label: "Gallery",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column buildChooseOptions(
    BuildContext context, {
    required Function func,
    required IconData iconData,
    required String label,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            print("object");
            func();
          },
          color: Theme.of(context).primaryColor,
          iconSize: SizeConfig.height * 6,
          icon: Icon(iconData),
        ),
        Text(label),
      ],
    );
  }
}

class IsFoodDonor extends StatefulWidget {
  const IsFoodDonor(
      {Key? key, required this.controller, required this.panController})
      : super(key: key);

  final TextEditingController controller;
  final TextEditingController panController;

  @override
  State<IsFoodDonor> createState() => _IsFoodDonorState();
}

class _IsFoodDonorState extends State<IsFoodDonor> {
  bool isFoodDonor = false;

  toggle(V) {
    isFoodDonor = !isFoodDonor;
    setState(() {});
    widget.controller.text = isFoodDonor.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isFoodDonor,
              onChanged: toggle,
              activeColor: Theme.of(context).primaryColor,
            ),
            const Text("Are you a food donor?")
          ],
        ),
        if (isFoodDonor)
          SizedBox(
            height: SizeConfig.height * 2,
          ),
        if (isFoodDonor)
          GeneralTextField(
              title: "Pan No.",
              controller: widget.panController,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validate: (v) => ValidationMixin().validate(v!, "Pan No."),
              onFieldSubmitted: (_) {}),
      ],
    );
  }
}
