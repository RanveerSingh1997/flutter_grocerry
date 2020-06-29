import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Views/addtocart_page.dart';
import 'package:flutter_grocerry_app/Views/favourite_Page.dart';
import 'package:flutter_grocerry_app/Views/home_page.dart';
import 'package:flutter_grocerry_app/Views/profile_page.dart';
import 'package:flutter_grocerry_app/Views/signInPage.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';

class AppBarDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height=40.0;
    return Container(
      width:200,
      color:Colors.transparent,
       padding:EdgeInsets.only(bottom:320),
      child: Drawer(
        elevation:10,
        child:Container(
          height:400,
          width:200,
          decoration:appDrawerDecoration,
          child: ListView(
            children: <Widget>[
              Align(
                alignment:Alignment.topLeft,
                child: IconButton(
                  icon:Icon(Icons.clear),
                  onPressed:(){
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                height:height,
                child: ListTile(leading:Icon(Icons.home),title:Text('Home'),onTap:(){
                  Navigator.of(context).pushReplacementNamed(HomePage.routName);
                },),
              ),
              Divider(thickness:1,),
              Container(
                height:height,
                child: ListTile(leading:Icon(Icons.shopping_cart),title:Text('My Cart'),onTap:(){
                  Navigator.of(context).pushReplacementNamed(AddToCartPage.routName);
                },),
              ),
              Divider(thickness:1,),
              Container(
                height:height,
                child: ListTile(leading:Icon(Icons.favorite), title:Text('Favorite'),onTap:(){
                  Navigator.of(context).pushReplacementNamed(FavouriteItemPage.routName);
                },),
              ),
              Divider(thickness:1,),
              Container(
                height:height,
                child: ListTile(leading:Icon(Icons.person),title:Text('Profile'),onTap:(){
                  Navigator.of(context).pushReplacementNamed(ProfilePage.routName);
                },),
              ),
              Divider(thickness:1,),
              ListTile(leading:Icon(Icons.exit_to_app),title:Text('Logout'),onTap:(){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(SignInPage.routName);
              },),
            ],
          ),
        ),
      ),
    );
  }
}
