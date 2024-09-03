import 'package:flutter/material.dart';

import '/utils/size_config.dart';

// ignore: must_be_immutable
class GeneralElevatedButton extends StatelessWidget {
  final String title;
  final bool isSmallText;
  final Color? bgColor;
  final Color? fgColor;
  final VoidCallback? onPressed;
  final bool checkInternet;
  final double? borderRadius;
  final bool isDisabled;
  final double? height;
  final double? width;
  final double? marginH;
  final double? elevation;
  TextStyle? textStyle;

  GeneralElevatedButton({
    Key? key,
    this.isSmallText = false,
    required this.title,
    this.bgColor,
    this.fgColor,
    this.borderRadius,
    this.isDisabled = false,
    this.checkInternet = true,
    this.onPressed,
    this.height,
    this.width,
    this.marginH,
    this.textStyle,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (textStyle == null) {
      if (isSmallText) {
        textStyle = Theme.of(context).textTheme.labelSmall!.copyWith(
              color: fgColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            );
      } else {
        textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
              color: fgColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            );
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: marginH ?? 0,
      ),
      height: height ?? SizeConfig.height * 6,
      width: width ?? SizeConfig.width * 100,
      child: ElevatedButton(
        key: key,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: MaterialStateProperty.all(
            isDisabled
                ? Theme.of(context).disabledColor
                : bgColor ?? Theme.of(context).primaryColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
            ),
          ),
        ),
        onPressed: isDisabled
            ? () {}
            : () async {
                onPressed!();
                // if (!checkInternet) {
                // } else {
                //   final provider =
                //       Provider.of<ConnectivityProvider>(context, listen: false);

                //   if (provider.isConnected) {
                //     onPressed!();
                //   } else {
                //     ShowAlertDialog(
                //             okFunc: () => Navigator.pop(context),
                //             body: Text(LocaleKeys.noInternetDescription.tr()),
                //             title: LocaleKeys.noInternet.tr())
                //         .showAlertDialog(context);
                //   }
                // }
              },
        child: Text(
          title,
          style: textStyle,
        ),
      ),
    );
  }
}
