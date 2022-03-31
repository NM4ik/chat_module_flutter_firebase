import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

const kDefaultPadding = 20.0;
const kDefaultGradient = [Color(0xFFAC83F0), Color(0xFF948CF3)];


/// message styles

const styleSomebody = BubbleStyle(
  nip: BubbleNip.leftTop,
  color: Colors.white,
  elevation: 3,
  padding: BubbleEdges.all(10),
  margin: BubbleEdges.only(top: 8, right: 50),
  alignment: Alignment.topLeft,
);

const styleMe = BubbleStyle(
  nip: BubbleNip.rightTop,
  color: Color(0xFFAC83F0),
  elevation: 3,
  padding: BubbleEdges.all(10),
  margin: BubbleEdges.only(top: 8, left: 50),
  alignment: Alignment.topRight,
);