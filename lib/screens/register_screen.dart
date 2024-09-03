import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_food/screens/register_profile_screen.dart';
import 'package:save_food/utils/navigate.dart';
import 'package:save_food/widgets/curved_body_widget.dart';
import 'package:save_food/widgets/general_elevated_button.dart';
import '/constants/constants.dart';
import '/utils/size_config.dart';
import '/utils/validation_mixin.dart';
import '/widgets/general_alert_dialog.dart';
import '/widgets/general_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      // backgroundColor: Colors.white,
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            children: [
              Image.asset(
                ImageConstants.logo,
                width: SizeConfig.width * 40,
                height: SizeConfig.height * 25,
              ),
              SizedBox(
                height: SizeConfig.height,
              ),
              GeneralTextField(
                title: "Email",
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validate: (value) => ValidationMixin().validateEmail(value!),
                onFieldSubmitted: (_) {},
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
              GeneralTextField(
                title: "Password",
                isObscure: true,
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validate: (value) => ValidationMixin().validatePassword(value!),
                onFieldSubmitted: (_) {
                  confirmPasswordFocusNode.requestFocus();
                },
              ),
              SizedBox(height: SizeConfig.height * 2),
              GeneralTextField(
                title: "Confirm Password",
                isObscure: true,
                focusNode: confirmPasswordFocusNode,
                controller: confirmPasswordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validate: (value) => ValidationMixin().validatePassword(
                    passwordController.text,
                    isConfirmPassword: true,
                    confirmValue: value!),
                onFieldSubmitted: (_) {
                  submit(context);
                },
              ),
              SizedBox(height: SizeConfig.height * 4),
              GeneralElevatedButton(
                onPressed: () async {
                  await submit(context);
                },
                title: "Register",
              ),
            ],
          ),
        )),
      ),
    );
  }

  submit(context) async {
    try {
      if (formKey.currentState!.validate()) {
        final firebaseAuth = FirebaseAuth.instance;
        GeneralAlertDialog().customLoadingDialog(context);
        final credential = await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        if (credential.user?.uid != null) {
          Navigator.pop(context);
          navigate(
            context,
            RegisterProfileScreen(
              uuid: credential.user!.uid,
              email: credential.user!.email!,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      var message = "";
      if (ex.code == "email-already-in-use") {
        message = "The email address is already used";
      } else if (ex.code == "weak-password") {
        message = "The password is too weak";
      }
      await GeneralAlertDialog().customAlertDialog(context, message);
    } catch (ex) {
      Navigator.pop(context);
      await GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
