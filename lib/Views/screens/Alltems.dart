import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/product.dart';
import 'package:flutter_grocerry_app/Widgets/foodItem_CardView.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:provider/provider.dart';
import '../productsdetails_page.dart';

class AllItems extends StatelessWidget {
  final List<DocumentSnapshot> allItems;
  final String title;
  AllItems(this.allItems, this.title);
  static final String routName = '/AllItems';
  final _scaffoldKey=new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthUser>(context, listen: false);
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: 20.0),
        crossAxisCount: 2,
        crossAxisSpacing:10,
        mainAxisSpacing:10,
        children: List.generate(allItems.length, (index) {
          var favourites = Firestore.instance
              .collection('products')
              .document(allItems[index].documentID);
          return FittedBox(
            child: Column(
              mainAxisSize:MainAxisSize.min,
              children: <Widget>[
                FittedBox(
                  child: foodItem(Product.fromMap(allItems[index].data),
                      userId: auth.userId,
                      onTapped: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProductPage(
                                productData:
                                Product.fromMap(allItems[index].data),
                              );
                            },
                          ),
                        );
                      },
                      addToCart:(){
                        favourites.updateData({
                          "addtocart":
                          FieldValue.arrayUnion([auth.userId])
                        });
                         _scaffoldKey.currentState.hideCurrentSnackBar();
                         _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration:
                            Duration(seconds: 2),
                            content: Text(
                                '${allItems[index].data['name']} Item is added to your cart'),
                          ),
                        );
                      },
                      imgWidth: 120, onLike: () {
                    if (allItems[index]['favourite'].toString().contains(auth.userId)) {
                      favourites.updateData({
                        "favourite": FieldValue.arrayRemove([auth.userId])
                      });
                    } else {
                      favourites.updateData({
                        "favourite": FieldValue.arrayUnion([auth.userId])
                      });
                    }
                  }),
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          allItems[index]['name'],
                          style: foodNameText,
                        ),
                        Text(
                          'Rs '+allItems[index]['price'],
                          style: priceText,
                        ),
                      ],
                    ),
                    SizedBox(width:50,),
                    IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {}),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
