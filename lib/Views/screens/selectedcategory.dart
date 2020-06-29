import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/product.dart';
import 'package:flutter_grocerry_app/Widgets/foodItem_CardView.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:provider/provider.dart';

import '../productsdetails_page.dart';

class SelectedCategory extends StatelessWidget {
  static final String routName = '/SelectedCategpory';
  final _scaffoldKey=new GlobalKey<ScaffoldState>();
  final category;
  SelectedCategory(this.category);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        title: Text(category),
      ),
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('products')
                .where('catagory', isEqualTo: category)
                .snapshots(),
            builder: (context, snaps) {
              var auth = Provider.of<AuthUser>(context, listen: false);
              if(snaps.connectionState==ConnectionState.waiting){
                return Center(child:CircularProgressIndicator(),);
              }
              var item = snaps.data.documents;
              return GridView.builder(
                  itemCount: item.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:1,
                  ),
                  itemBuilder: (context, index) {
                    var favourites = Firestore.instance
                        .collection('products')
                        .document(item[index].documentID);
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: FittedBox(
                        child: Column(
                          children: <Widget>[
                            foodItem(Product.fromMap(item[index].data),onTapped: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductPage(
                                      productData: Product.fromMap(
                                          item[index].data),
                                    );
                                  },
                                ),
                              );
                            },),
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
                                      item[index]['name'],
                                      style: foodNameText,
                                    ),
                                    Text(
                                      'Rs '+item[index]['price'],
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
                      )
                    );
                  });
            }),
      ),
    );
  }
}
