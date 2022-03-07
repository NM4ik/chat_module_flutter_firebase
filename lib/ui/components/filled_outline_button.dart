import 'package:flutter/material.dart';

class FillOutlineButton extends StatelessWidget {
  const FillOutlineButton(
      {Key? key,
      required this.text,
      required this.press,
      required this.isFilled})
      : super(key: key);
  final String text;
  final VoidCallback press;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12, color: isFilled ? Colors.black : Colors.white, fontFamily: 'SF', fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        // fixedSize: const Size(150, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.white),
        ),
        primary: isFilled ? Colors.white : Colors.transparent,
      ),
    );
  }
}
