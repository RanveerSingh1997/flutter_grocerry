import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/product.dart';
import 'package:flutter_grocerry_app/Views/screens/selectedcategory.dart';
import 'package:flutter_grocerry_app/Widgets/appBar.dart';
import 'package:flutter_grocerry_app/Widgets/customWidgets.dart';
import 'package:flutter_grocerry_app/Widgets/foodItem_CardView.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'productsdetails_page.dart';

class HomePage extends StatefulWidget {
  static final String routName = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream category, products;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    category = Firestore.instance.collection('catagory').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title:Text('Grocery',style:GoogleFonts.vt323(letterSpacing:12.0,fontSize:26),),
      ),
      drawer: AppBarDrawer(),
      body: Container(
        decoration:BoxDecoration(
          color:Colors.grey[100],
          border:Border(
            top:BorderSide(color:Colors.grey[200],width:4),
            left:BorderSide(color:Colors.grey[200],width:4),
            right:BorderSide(color:Colors.grey[900],width:2),
            bottom:BorderSide(color:Colors.grey[800],width:4),
          )
        ),
        child: StreamBuilder(
          stream: category,
          builder: (context, productsTag) {
            return Column(
              children: <Widget>[
                headerTopCategories(context),
                sectionHeader('Cart Items'),
                Expanded(
                  child: dealsItem(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  var allcategory;

  Widget headerTopCategories(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        sectionHeader(
          'Categories',
        ),
        Container(
          height: 50,
          decoration:BoxDecoration(
              color:Colors.grey[100],
              border:Border(
                top:BorderSide(color:Colors.grey[400],width:4),
                left:BorderSide(color:Colors.grey[100],width:1),
                right:BorderSide(color:Colors.grey[100],width:1),
                bottom:BorderSide(color:Colors.grey[800],width:4),
              )
          ),
          child: StreamBuilder(
            stream: category,
            builder: (context, categorySnapshot) {
              if (categorySnapshot.connectionState == ConnectionState.waiting) {
                return Center();
              }
              allcategory = categorySnapshot.data.documents;
              return ListView.builder(
                itemCount: allcategory.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return headerCategoryItem(allcategory[index]['name'],
                      onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SelectedCategory(allcategory[index]['name'])));
                  });
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget dealsItem() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          var productDocs = snapshot.data.documents;
          var auth = Provider.of<AuthUser>(context, listen: false);
          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(productDocs.length, (index) {
              var favourites = Firestore.instance
                  .collection('products')
                  .document(productDocs[index].documentID);
              return FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    foodItem(
                      Product.fromMap(productDocs[index].data),
                      onLike: () async {
                        if (productDocs[index]['favourite']
                            .toString()
                            .contains(auth.userId)) {
                          favourites.updateData({
                            "favourite": FieldValue.arrayRemove([auth.userId])
                          });
                        } else
                          favourites.updateData({
                            "favourite": FieldValue.arrayUnion([auth.userId])
                          });
                      },
                      userId: auth.userId,
                      onTapped: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProductPage(
                                productData:
                                    Product.fromMap(productDocs[index].data),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              productDocs[index]['name'],
                              style: foodNameText,
                            ),
                            Text(
                              'Rs ' + productDocs[index]['price'],
                              style: priceText,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () {}),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
  }
}
