import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_food/utils/file_compressor.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import 'package:save_food/widgets/general_text_button.dart';
import 'package:provider/provider.dart';

import '/constants/constants.dart';
import '/providers/user_provider.dart';
import '/utils/firebase_helper.dart';
import '/utils/size_config.dart';
import '/utils/validation_mixin.dart';
import '/widgets/curved_body_widget.dart';
import '/widgets/general_alert_dialog.dart';
import '/widgets/general_text_field.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  // final String imageUrl;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final isFoodDonorController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final profileData = Provider.of<UserProvider>(context).user;
    // nameController.text = profileData.name ?? "";
    // ageController.text =
    //     profileData.age != null ? profileData.age.toString() : "";
    // addressController.text = profileData.address ?? "";
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
              Hero(
                tag: "image-url",
                child: SizedBox(
                  height: SizeConfig.height * 15,
                  width: SizeConfig.height * 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SizeConfig.height * 8),
                    child: profileData.image == null &&
                            profileData.tempImage == null
                        ? Icon(
                            Icons.person,
                            size: SizeConfig.height * 15,
                            color: Theme.of(context).primaryColor,
                          )
                        : Image.memory(
                            base64Decode(
                                profileData.image ?? profileData.tempImage!),
                            fit: BoxFit.cover,
                            height: SizeConfig.height * 15,
                            width: SizeConfig.height * 15,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              Text(
                "Edit your profile",
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
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validate: (value) =>
                    ValidationMixin().validate(value!, "Phone Number"),
                onFieldSubmitted: (_) {},
              ),
              // SizedBox(
              //   height: SizeConfig.height * 2,
              // ),
              // IsFoodDonor(
              //   controller: isFoodDonorController,
              // ),
              SizedBox(
                height: SizeConfig.height * 4,
              ),
              GeneralTextButton(
                onPressed: () async {
                  await showBottomSheet(context);
                  // if (map.isNotEmpty) {}
                },
                title: "Choose Image",
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              GeneralElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      final map =
                          Provider.of<UserProvider>(context, listen: false)
                              .updateUser(
                        name: nameController.text,
                        address: addressController.text,
                        isFoodDonor: profileData.isFoodDonor,
                        panNumber: profileData.panNumber,
                        phoneNumber: phoneController.text,
                      );
                      await FirebaseHelper().addOrUpdateContent(
                        context,
                        collectionId: UserConstants.userCollection,
                        whereId: UserConstants.userId,
                        whereValue: profileData.uuid,
                        map: map,
                      );
                      Navigator.pop(context);
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
                      final int sizeInBytes = await xFile.length();
                      final double sizeInMb = sizeInBytes / 1000000;
                      if (sizeInMb > 1.0) {
                        final compressedFile = await compressFile(xFile);
                        if (compressedFile != null) {
                          Provider.of<UserProvider>(context, listen: false)
                              .updateUserImage(base64Encode(compressedFile));
                        }
                      } else {
                        final unit8list = await xFile.readAsBytes();
                        Provider.of<UserProvider>(context, listen: false)
                            .updateUserImage(base64Encode(unit8list));
                      }
                    }
                  },
                  iconData: Icons.camera_outlined,
                  label: "Camera",
                ),
                buildChooseOptions(
                  context,
                  func: () async {
                    final xFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (xFile != null) {
                      final int sizeInBytes = await xFile.length();
                      final double sizeInMb = sizeInBytes / 1000000;
                      if (sizeInMb > 1.0) {
                        final compressedFile = await compressFile(xFile);
                        if (compressedFile != null) {
                          Provider.of<UserProvider>(context, listen: false)
                              .updateUserImage(base64Encode(compressedFile));
                        }
                      } else {
                        final unit8list = await xFile.readAsBytes();
                        Provider.of<UserProvider>(context, listen: false)
                            .updateUserImage(base64Encode(unit8list));
                      }

                      Navigator.pop(context);
                    }
                  },
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
  const IsFoodDonor({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

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
    return Row(
      children: [
        Checkbox(
          value: isFoodDonor,
          onChanged: toggle,
        ),
        Text("Are you a food donor?")
      ],
    );
  }
}
