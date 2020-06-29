import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';

Widget headerCategoryItem(name,{onPressed}) {
  return GestureDetector(
    onTap:onPressed,
    child: Padding(
      padding: const EdgeInsets.only(left:10),
      child: Chip(
        elevation:10,
        label:Text(name+' >',style:categoryText,),
      ),
    ),
  );
}
Widget sectionHeader(String headerTitle) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(headerTitle.toUpperCase(),
              style: h3.copyWith(fontSize: 17, color: Colors.black87)),
        ),
      ],
    ),
  );
}
