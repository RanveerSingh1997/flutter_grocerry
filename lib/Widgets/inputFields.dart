import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

Container fryoTextInput(String hintText,
    {prefix,
    onTap,
    onValidator,
    onChanged,
    onEditingComplete,
    onSubmitted,
    keyboardType}) {
  return Container(
    decoration: BoxDecoration(
        border: Border(
      top: BorderSide(color: Colors.grey[300], width: 2),
      left: BorderSide(color: Colors.grey[300], width: 2),
      right: BorderSide(color: Colors.grey[800], width: 4),
      bottom: BorderSide(color: Colors.grey[900], width: 4),
    )),
    margin: EdgeInsets.only(top: 13),
    child: Container(
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[300], width: 2),
            left: BorderSide(color: Colors.grey[300], width: 2),
            right: BorderSide(color: Colors.grey[500], width: 4),
            bottom: BorderSide(color: Colors.grey[500], width: 4),
          )),
      child: TextFormField(
        onTap: onTap,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onSubmitted,
        validator: onValidator,
        autocorrect: true,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[100],
          hintText: hintText,
          prefix: prefix,
        ),
        keyboardType: keyboardType,
        style:GoogleFonts.vt323(fontSize:22),
      ),
    ),
  );
}
