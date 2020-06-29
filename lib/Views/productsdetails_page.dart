import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/product.dart';
import 'package:flutter_grocerry_app/Views/screens/checkoutPage.dart';
import 'package:flutter_grocerry_app/Widgets/colors.dart';
import 'package:flutter_grocerry_app/Widgets/customButton.dart';
import 'package:flutter_grocerry_app/Widgets/foodItem_CardView.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:provider/provider.dart';



class ProductPage extends StatefulWidget {
  static final String routName = 'ProductPage';
  final String pageTitle;
  Product productData;

  ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthUser>(context, listen: false);
    var addToCart = Firestore.instance
        .collection('products')
        .document(widget.productData.id);
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          leading: BackButton(
            color: darkText,
          ),
          title: Text(widget.productData.name, style: h4),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 100, bottom: 100),
                        padding: EdgeInsets.only(top: 100, bottom: 50),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.productData.name, style: h5),
                            Text('Rs '+widget.productData.price, style: h3),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 25),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('Quantity', style: h6),
                                    margin: EdgeInsets.only(bottom: 15),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CustomButton(
                                        icon: Icons.remove,
                                        onPress: () {
                                          setState(() {
                                            if (_quantity == 1) return;
                                            _quantity -= 1;
                                          });
                                        },
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(_quantity.toString(),
                                            style: h3),
                                      ),
                                      CustomButton(
                                        icon: Icons.add,
                                        onPress: () {
                                          setState(() {
                                            _quantity += 1;
                                          });
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 180,
                              child: CustomFlatButton(
                                  text: 'Buy Now',
                                  onPress: () async{
                                    await auth.addProducts(CartItem(
                                      id: widget.productData.id,
                                      name: widget.productData.name,
                                      price: widget.productData.price,
                                      imageUrl:widget.productData.images,
                                      quantity:_quantity,
                                      discount:widget.productData.discount
                                    ));
                                    Navigator.of(context).pushReplacementNamed(CheckoutPage.routName);
                                  }),
                            ),
                            SizedBox(height:30,),
                            Container(
                              width: 180,
                              child: CustomFlatButton(
                                  text: 'Add to Cart',
                                  onPress: () {
                                    addToCart.updateData({
                                      "addtocart":
                                          FieldValue.arrayUnion([auth.userId])
                                    });
                                  }),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color:Colors.black,
                              width:1
                            ),
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, .05))
                            ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        height: 160,
                        child: foodItem(widget.productData,
                            userId: auth.userId,
                            isProductPage: true,
                            onTapped: () {},
                            imgWidth: 250,
                            onLike: () {}),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
