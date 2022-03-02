import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.text, required this.press, required this.color}) : super(key: key);
  final String text;
  final Color color;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: press, child: Text(text), style: ElevatedButton.styleFrom(
      elevation: 0,
      fixedSize: Size(MediaQuery.of(context).size.width, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),),
      primary: color,
    ),);
  }
}
