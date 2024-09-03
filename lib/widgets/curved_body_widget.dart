import 'package:flutter/material.dart';
import '/constants/constants.dart';
import '/utils/size_config.dart';

class CurvedBodyWidget extends StatelessWidget {
  final Widget widget;
  final Color color;

  const CurvedBodyWidget({
    required this.widget,
    this.color = const Color(0xffEBEEF2), // Default color
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height * 100,
      width: SizeConfig.width * 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        color: color, // Use the provided color or default
      ),
      padding: basePadding,
      child: widget,
    );
  }
}
