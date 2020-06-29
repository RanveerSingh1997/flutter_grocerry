import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';


const logoStyle = TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 30,
    color: Colors.black54,
    letterSpacing: 2);

const logoWhiteStyle = TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 21,
    letterSpacing: 2,
    color: Colors.white);
const whiteText = TextStyle(color: Colors.white, fontFamily: 'Poppins');
const disabledText = TextStyle(color: Colors.grey, fontFamily: 'Poppins');
const contrastText = TextStyle(
    color: primaryColor, fontFamily: 'Poppins', fontSize: 17);
const contrastTextBold = TextStyle(
    color: primaryColor, fontFamily: 'Poppins', fontWeight: FontWeight.w600);

final h3 = GoogleFonts.orbitron(
  color: Colors.black,
  fontSize: 24,
  fontWeight: FontWeight.w800,
);

final h4 = GoogleFonts.orbitron(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

final h5 = GoogleFonts.orbitron(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

final h6 = GoogleFonts.orbitron(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);


final priceText = GoogleFonts.vt323(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w800,
);

final foodNameText = GoogleFonts.vt323(
  color: Colors.black,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const tabLinkStyle =
TextStyle(fontWeight: FontWeight.w500);

final taglineText = GoogleFonts.vt323(color: Colors.grey,);
final categoryText = GoogleFonts.vt323(
  color: Color(0xff444444),
  fontWeight: FontWeight.w700,
);

const inputFieldTextStyle =
TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500);

const inputFieldHintTextStyle =
TextStyle(fontFamily: 'Poppins', color: Color(0xff444444));

const inputFieldPasswordTextStyle = TextStyle(
    fontFamily: 'Poppins', fontWeight: FontWeight.w500, letterSpacing: 3);

const inputFieldHintPaswordTextStyle = TextStyle(
    fontFamily: 'Poppins', color: Color(0xff444444), letterSpacing: 2);

const authPlateDecoration = BoxDecoration(
  color: white,
  boxShadow: [
    BoxShadow(
        color: Colors.grey,
        blurRadius: 10,
        spreadRadius: 5,
        offset: Offset(0, 1)),
    BoxShadow(
        color: Colors.grey,
        blurRadius: 10,
        spreadRadius: 15,
        offset: Offset(0, 1))
  ],
);

const userInfoPlateDecoration = BoxDecoration(
  color: white,
  boxShadow: [
    BoxShadow(
        color: Color.fromRGBO(0, 0, 0, .1),
        blurRadius: 10,
        spreadRadius: 5,
        offset: Offset(0, 1))
  ],
  borderRadius: BorderRadiusDirectional.only(
    topEnd: Radius.circular(20),
    topStart: Radius.circular(20),
  ),
);

const inputFieldFocusedBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
  borderSide: BorderSide(
    color: primaryColor,
  ),
);


const inputFieldDefaultBorderStyle = OutlineInputBorder(
  gapPadding: 0,
  borderRadius: BorderRadius.all(
    Radius.circular(6),
  ),
);

final appDrawerDecoration = BoxDecoration(
    color: Colors.grey[100],
    border: Border(
      bottom: BorderSide(
          color: Colors.grey,
          width: 4,
          style: BorderStyle.solid),
      right: BorderSide(
          color: Colors.grey,
          width: 4,
          style: BorderStyle.solid),
    )
);
