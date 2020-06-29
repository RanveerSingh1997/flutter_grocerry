import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/product.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'colors.dart';
import 'customButton.dart';


Widget foodItem(Product food,
    {String userId,
    double imgWidth,
    addToCart,
    onLike,
    onTapped,
    bool isProductPage = false}) {
  return Container(
    width: 180,
    height: 180,
    decoration:BoxDecoration(
      border:Border(
        top:BorderSide(color:Colors.grey[300],width:2),
        left:BorderSide(color:Colors.grey[300],width:2),
        right:BorderSide(color:Colors.grey[800],width:4),
        bottom:BorderSide(color:Colors.grey[800],width:2),
      )
    ),
    child: Container(
      decoration:BoxDecoration(
          border:Border(
            top:BorderSide(color:Colors.grey[200],width:2),
            left:BorderSide(color:Colors.grey[800],width:2),
            right:BorderSide(color:Colors.grey[500],width:4),
            bottom:BorderSide(color:Colors.grey[500],width:4),
          )
      ),
      child: GestureDetector(
        onTap: onTapped,
        child: Container(
          color: white,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Center(
                  child: Image.network(
                    food.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Chip(
                  label: Text(food.discount, style: h6),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CustomFavouriteIconButton(
                  color: primaryColor,
                  icon:food.favourite.contains(userId)?Icons.favorite_border:Icons.favorite_border,
                  onPress: onLike,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
