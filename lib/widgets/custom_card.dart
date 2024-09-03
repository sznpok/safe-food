import 'package:flutter/material.dart';
import 'package:save_food/constants/constants.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.children,
    this.backgroundColor,
    this.borderRadius,
    this.width,
    this.height,
    this.paddingA,
    this.marginA,
    this.centerC = false,
    this.centerM = false,
  }) : super(key: key);

  final List<Widget>? children;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? width;
  final double? height;
  final double? paddingA;
  final EdgeInsetsGeometry? marginA;
  final bool centerC;
  final bool centerM;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: marginA,
      height: height,
      padding: paddingA != null ? EdgeInsets.all(paddingA!) : basePadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
      child: Column(
        crossAxisAlignment:
            centerC ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment:
            centerM ? MainAxisAlignment.center : MainAxisAlignment.start,
        mainAxisSize: centerM ? MainAxisSize.max : MainAxisSize.min,
        children: [if (children != null) ...children!],
      ),
    );
  }
}
