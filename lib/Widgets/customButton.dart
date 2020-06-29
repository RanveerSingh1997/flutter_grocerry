import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';


class CustomFavouriteIconButton extends StatelessWidget{
  final Color color;
  final IconData icon;
  final Function onPress;
  CustomFavouriteIconButton({this.color,this.icon,this.onPress});
  @override
  Widget build(BuildContext context) {
    return IconButton(icon:Icon(icon,color:color,), onPressed:onPress);
  }
}


class CustomButton extends StatelessWidget {
  final Function onPress;
  final IconData icon;
  CustomButton({this.onPress,this.icon});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onPress,
      child: Container(
        width:30,
        height:30,
        decoration:BoxDecoration(
          border:Border.all(
            color:Colors.black,
            width:1
          )
        ),
        child: Icon(icon),
      ),
    );
  }
}

class CustomFlatButton extends StatelessWidget {
  final String text;
  final Function onPress;
  CustomFlatButton({this.onPress,this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onPress,
      child:Container(
        padding:EdgeInsets.symmetric(vertical:8),
        decoration:BoxDecoration(
            border:Border.all(
                color:Colors.black,
                width:1
            )
        ),
        child:Text(text,textAlign:TextAlign.center,style:h6,),
      ),
    );
  }
}
