import 'package:flutter/material.dart';
import 'package:save_food/utils/size_config.dart';
import '/constants/constants.dart';

class GeneralDropDown extends StatefulWidget {
  const GeneralDropDown(this.controller, {Key? key}) : super(key: key);

  // final Function(String) method;
  final TextEditingController controller;

  @override
  State<GeneralDropDown> createState() => _GeneralDropDownState();
}

class _GeneralDropDownState extends State<GeneralDropDown> {
  final List<DropdownMenuItem<String>> list = [];

  String? selectedValue;

  @override
  void initState() {
    super.initState();

    for (var e in FilterOptionConstant.filterList) {
      list.add(
        DropdownMenuItem(
          child: Text(e),
          value: e,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfff3f3f3),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 2,
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        elevation: 3,
        items: list,
        onChanged: (value) {
          widget.controller.text = value!;
          setState(() {
            selectedValue = value;
          });
        },
        hint: const Text("Select"),
        underline: const SizedBox.shrink(),
        value: selectedValue,
      ),
    );
  }
}
