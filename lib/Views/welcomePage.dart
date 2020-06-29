import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Views/signInPage.dart';
import 'package:flutter_grocerry_app/Widgets/customButton.dart';
import 'package:google_fonts/google_fonts.dart';


class WelcomePage extends StatelessWidget {
  static final String routName = '/welcomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
          border:Border(
            bottom:BorderSide(color:Colors.grey,width:1)
          ),
          boxShadow:[
            BoxShadow(color:Colors.grey[100],blurRadius:10,spreadRadius:10)
          ]
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/grocery.png',width:140,height:140,fit:BoxFit.cover,),

              Text('Grocery',style:GoogleFonts.monoton(fontSize:60,letterSpacing:3.0),),
              SizedBox(height:30,),
              Container(
                width: 200,
                margin: EdgeInsets.all(0),
                child: CustomFlatButton(
                  text:'SIGN IN',
                  onPress: () {
                    Navigator.pushReplacementNamed(
                        context, SignInPage.routName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
