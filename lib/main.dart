import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Views/addtocart_page.dart';
import 'package:flutter_grocerry_app/Views/favourite_Page.dart';
import 'package:flutter_grocerry_app/Views/home_page.dart';
import 'package:flutter_grocerry_app/Views/productsdetails_page.dart';
import 'package:flutter_grocerry_app/Views/profile_page.dart';
import 'package:flutter_grocerry_app/Views/signInPage.dart';
import 'package:flutter_grocerry_app/Views/userInfoPage.dart';
import 'package:flutter_grocerry_app/Views/welcomePage.dart';
import 'package:flutter_grocerry_app/Widgets/colors.dart';
import 'package:provider/provider.dart';
import 'Views/screens/checkoutPage.dart';
import 'Widgets/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthUser(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grocery',
        theme: ThemeData(
            primaryColor:white, //Color(0xffA6AF5E),
            primarySwatch:Colors.blueGrey,
            appBarTheme: AppBarTheme(
                elevation: 0,
                actionsIconTheme: IconThemeData(color: Colors.grey[700]),
                color: Colors.white,
                textTheme: TextTheme(title: h3.copyWith(color: primaryColor)),
                iconTheme: IconThemeData(color: primaryColor))),
        home: WelcomePage(),
        routes: {
          WelcomePage.routName: (context) => WelcomePage(),
          HomePage.routName: (context) => HomePage(),
          ProductPage.routName: (context) => ProductPage(),
          SignInPage.routName: (context) => SignInPage(),
          UserInfoPage.routName: (context) => UserInfoPage(),
          CheckoutPage.routName: (context) => CheckoutPage(),
          AddToCartPage.routName:(context)=>AddToCartPage(),
          FavouriteItemPage.routName:(context)=>FavouriteItemPage(),
          ProfilePage.routName:(context)=>ProfilePage(),
        },
      ),
    );
  }
}
