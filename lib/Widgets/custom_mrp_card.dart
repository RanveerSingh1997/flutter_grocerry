import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';

class CustomMRPCard extends StatelessWidget {
  final String title;
  final String price;
  CustomMRPCard(this.title, this.price);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title,style:priceText),
          Text(price,style: priceText.copyWith(color: Colors.green),),
        ],
      ),
    );
  }
}
