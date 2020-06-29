import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/product.dart';
import 'package:flutter_grocerry_app/Views/productsdetails_page.dart';
import 'package:flutter_grocerry_app/Views/screens/Alltems.dart';
import 'package:flutter_grocerry_app/Views/screens/checkoutPage.dart';
import 'package:flutter_grocerry_app/Views/userInfoPage.dart';
import 'package:flutter_grocerry_app/Widgets/appBar.dart';
import 'package:flutter_grocerry_app/Widgets/colors.dart';
import 'package:flutter_grocerry_app/Widgets/customButton.dart';
import 'package:flutter_grocerry_app/Widgets/customWidgets.dart';
import 'package:flutter_grocerry_app/Widgets/custom_mrp_card.dart';
import 'package:flutter_grocerry_app/Widgets/foodItem_CardView.dart';
import 'package:flutter_grocerry_app/Widgets/neumorphicContainer.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class AddToCartPage extends StatefulWidget {
  static final String routName='/AddToCartPage';
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  var user;
  Stream _cart, _category;

  onCheckout(String userId, context) async {
    final snapshot =
        await Firestore.instance.collection('users').document(userId).get();
    if (!snapshot.exists) {
      Navigator.pushReplacementNamed(context, UserInfoPage.routName);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CheckoutPage()));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<AuthUser>(context, listen: false);
    _category = Firestore.instance
        .collection('products')
        .where('tags', arrayContains: 'Top Selling Items')
        .snapshots();
    _cart = Firestore.instance
        .collection('products')
        .where('addtocart', arrayContains: user.userId)
        .snapshots();
    _cart.listen((snap) {
      var cartItem = snap.documents;
      for (int i = 0; i < cartItem.length; i++) {
        user.addProducts(
          CartItem(
            id: cartItem[i].documentID,
            name: cartItem[i]['name'],
            discount: cartItem[i]['discount'],
            quantity: 1,
            imageUrl: cartItem[i]['images'],
            price: cartItem[i]['price'],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title:Text('Grocery',style:GoogleFonts.vt323(letterSpacing:12.0,fontSize:26),),
      ),
      drawer:AppBarDrawer(),
      backgroundColor:Theme.of(context).primaryColor,
      body: StreamBuilder(
        stream: _cart,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final cartItem = snapshot.data.documents;
          var _products = user.products.values.toList();
          return !snapshot.hasData || _products.length == 0
              ? Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ListView(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/vegetable.png',
                        fit: BoxFit.contain,
                        height: 200,
                        width: 150,
                      ),
                      Text(
                        'No Item in your Cart',
                        textAlign: TextAlign.center,
                        style: contrastTextBold,
                      ),
                      Text(
                        'Your Favourite are just click away',
                        textAlign: TextAlign.center,
                        style: contrastText,
                      ),
                      CustomFlatButton(
                        text: 'Start Shopping',
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
                                              } else
                                                favourites.updateData({
                                                  "favourite":
                                                      FieldValue.arrayUnion(
                                                          [user.userId])
                                                });
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
                  height: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CustomMRPCard(
                            'M.R.P',
                            '${user.totalAmount()}',
                          ),
                          CustomMRPCard('Product Discount',
                              '-${user.totalDiscountAmount()}'),
                          CustomMRPCard('Delivery Charge', '+50'),
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            thickness: 1.0,
                            color: darkText,
                          ),
                          CustomMRPCard(
                              'Sub Total', '${user.totalEstimatedAmount()}'),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: CustomFlatButton(
                              text: 'Checkout',
                              onPress: () {
                                onCheckout(user.userId, context);
                              },
                            ),
                          ),
                        ],
                      )),
                      Text(
                        'Your Cart List',
                        style: h4,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            var item = Firestore.instance
                                .collection('products')
                                .document(cartItem[index].documentID);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 4.0, right: 4.0, bottom: 6.0),
                              child: NeumorphicContainer(
                                bevel: 0,
                                color: white,
                                child: Row(
                                  children: <Widget>[
                                    Image.network(
                                      _products[index].imageUrl[0],
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _products[index].name,
                                            style: h3.copyWith(
                                                color: Colors.black54,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            'Price: ' +
                                                _products[index].price,
                                            style: priceText,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              CustomButton(
                                                  icon: Icons.remove,
                                                  onPress: () {
                                                    if (_products[index]
                                                            .quantity ==
                                                        1) {
                                                      item.updateData({
                                                        "addtocart": FieldValue
                                                            .arrayRemove(
                                                                [user.userId])
                                                      });
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          content: Text('${_products[index].name} Item is removed from Favourite List'),
                                                        ),
                                                      );
                                                      user.removeItem(
                                                          _products[index].id);
                                                    }
                                                    if (_products[index]
                                                            .quantity >
                                                        1) {
                                                      user.subtractQuantity(
                                                          _products[index].id);
                                                      Scaffold.of(context)
                                                          .hideCurrentSnackBar();

                                                    }
                                                  }),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Text(_products[index]
                                                    .quantity
                                                    .toString()),
                                              ),
                                              CustomButton(
                                                  icon: Icons.add,
                                                  onPress: () {
                                                    user.addQuantity(
                                                        _products[index].id);
                                                  }),
                                            ],
                                          )
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
    );
  }
}
