import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/product.dart';
import 'package:flutter_grocerry_app/Views/productsdetails_page.dart';
import 'package:flutter_grocerry_app/Views/screens/Alltems.dart';
import 'package:flutter_grocerry_app/Widgets/appBar.dart';
import 'package:flutter_grocerry_app/Widgets/colors.dart';
import 'package:flutter_grocerry_app/Widgets/customButton.dart';
import 'package:flutter_grocerry_app/Widgets/customWidgets.dart';
import 'package:flutter_grocerry_app/Widgets/foodItem_CardView.dart';
import 'package:flutter_grocerry_app/Widgets/neumorphicContainer.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

class FavouriteItemPage extends StatefulWidget {
  static final String routName='/Favoritepage';
  @override
  _FavouriteItemPageState createState() => _FavouriteItemPageState();
}

class _FavouriteItemPageState extends State<FavouriteItemPage> {
  var user;
  Stream _category;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    user = Provider.of<AuthUser>(context, listen: false);
    _category = Firestore.instance
        .collection('products')
        .where('tags', arrayContains: 'Top Selling Items')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title:Text('Grocery',style:GoogleFonts.vt323(letterSpacing:12.0,fontSize:26),),
      ),
      drawer:AppBarDrawer(),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('products')
              .where('favourite', arrayContains: user.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var cart = snapshot.data.documents;
            return !snapshot.hasData || cart.length == 0
                ? Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/cart.png',
                          fit: BoxFit.contain,
                          height: 150,
                          width: 150,
                        ),
                        Text(
                          'Your Favourite are just click away',
                          textAlign: TextAlign.center,
                          style: contrastText,
                        ),
                        CustomFlatButton(
                          text: 'Add Favourite',
                          onPress: () {
                            Navigator.pushReplacementNamed(
                                context, HomePage.routName);
                          },
                        ),
                        Container(
                          height: 250,
                          child: StreamBuilder(
                              stream: _category,
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                var item = snap.data.documents;
                                return Column(
                                  children: <Widget>[
                                    sectionHeader('Top Selling Items',),
                                    Expanded(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: item.length,
                                          itemBuilder: (context, index) {
                                            var favourites = Firestore.instance
                                                .collection('products')
                                                .document(item[index].documentID);
                                            return foodItem(
                                              Product.fromMap(item[index].data),
                                              onLike: () async {
                                                if (item[index]['favourite']
                                                    .toString()
                                                    .contains(user.userId)) {
                                                  favourites.updateData({
                                                    "favourite":
                                                        FieldValue.arrayRemove(
                                                            [user.userId])
                                                  });
                                                } else {
                                                  favourites.updateData({
                                                    "favourite":
                                                        FieldValue.arrayUnion(
                                                            [user.userId])
                                                  });
                                                }
                                              },
                                              userId: user.userId,
                                              onTapped: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return ProductPage(
                                                        productData:
                                                            Product.fromMap(
                                                                item[index].data),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                    ),
                                  ],
                                );
                              }),
                        )
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5.0),
                                child: NeumorphicContainer(
                                  bevel: .5,
                                  color: white,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image.network(
                                        cart[index]['images'][0],
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width: 30.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              cart[index]['name'],
                                              style: foodNameText,
                                            ),
                                            Text(
                                              'Price: ' + cart[index]['price'],
                                              style: priceText,
                                            ),
                                            Container(
                                              width: 120,
                                              child: CustomFlatButton(
                                                text: 'Add Cart',
                                                onPress: () {
                                                  Firestore.instance
                                                      .collection('products')
                                                      .document(
                                                          cart[index].documentID)
                                                      .updateData({
                                                    "addtocart":
                                                        FieldValue.arrayUnion(
                                                            [user.userId])
                                                  });
                                                  Scaffold.of(context)
                                                      .hideCurrentSnackBar();
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      content: Text(
                                                          '${cart[index].data['name']} Item is added to Cart List'),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Column(
                                          children: <Widget>[
                                            CustomFavouriteIconButton(
                                              color: primaryColor,
                                              icon: Icons.favorite,
                                              onPress: () {
                                                Firestore.instance
                                                    .collection('products')
                                                    .document(
                                                        cart[index].documentID)
                                                    .updateData({
                                                  'favourite':
                                                      FieldValue.arrayRemove(
                                                          [user.userId])
                                                });
                                                Scaffold.of(context)
                                                    .hideCurrentSnackBar();
                                                Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(seconds: 2),
                                                    content: Text(
                                                        '${cart[index].data['name']} Item is removed from Favourite List'),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
