import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget customTextfield({
  required TextEditingController controller,
  TextInputType type = TextInputType.name,
  Color borderColor = Colors.black,
  String label = "Enter Text",
  bool enabled = true,
  Widget leading = const SizedBox(),
  Widget trailing = const SizedBox(),
}) {
  return TextFormField(
    keyboardType: type,
    controller: controller,
    maxLines: null,
    style: style,
    enabled: enabled,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.blue,
        labelText: label,
        labelStyle: style,
        prefixIcon: leading,
        suffixIcon: trailing,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(10))),
  );
}

Widget customPasswordfield(
    {required TextEditingController controller,
    TextInputType type = TextInputType.name,
    Color borderColor = Colors.black,
    String label = "Enter Text",
    Widget leading = const SizedBox(),
    Widget trailing = const SizedBox(),
    bool obsicure = true}) {
  return TextFormField(
    keyboardType: type,
    obscureText: obsicure,
    controller: controller,
    style: style,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.blue,
        labelText: label,
        labelStyle: style,
        prefixIcon: leading,
        suffixIcon: trailing,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(10))),
  );
}

Widget picker(String placeHolder) {
  return DottedBorder(
    radius: const Radius.circular(20),
    dashPattern: const [4, 4],
    child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            placeHolder,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )),
  );
}

Widget customButton(
    {required String text,
    required Function onTap,
    Color bgColor = Colors.blue,
    Color fgColor = Colors.white,
    double height = 50,
    double width = 600,
    bool loader = false,
    double borderRadius = 100}) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        foregroundColor: fgColor,
        backgroundColor: bgColor,
        shadowColor: Colors.grey.shade800,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size.fromHeight(height),
      ),
      child: loader
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(text),
    ),
  );
}
