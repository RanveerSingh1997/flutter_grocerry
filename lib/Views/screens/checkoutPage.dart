import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/order.dart';
import 'package:flutter_grocerry_app/Widgets/customButton.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';

class CheckoutPage extends StatefulWidget {
  static final String routName = '/checkoutPage';

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    var product = Provider.of<AuthUser>(context);
    var products = product.products.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: ListView(
        children: [
          singleCartItem(product.totalEstimatedAmount().toString()),
          buildUserCard(
              address: product.userAddress, userName: product.userName),
          buildPayemntCard(onPress: () async {
            await Firestore.instance
                .collection('orders')
                .add(
                  Order.fromOrder(
                    Order(
                        customerName: product.userName,
                        totalPrice: product.totalEstimatedAmount(),
                        status: 1,
                        address: product.userAddress,
                        customerId: product.userId,
                        orderDate: DateTime.now(),
                        products: products.map((items) {
                          return CartItem.fromCart(CartItem(
                              id: items.id,
                              name: items.name,
                              price: items.price,
                              quantity: items.quantity,
                              discount: items.discount));
                        }).toList()),
                  ),
                )
                .then((value) async {
              await Firestore.instance
                  .collection('orders')
                  .document(value.documentID)
                  .updateData({'productId': value.documentID});
            }).whenComplete(() async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text(
                          'Thank you',
                          textAlign: TextAlign.center,
                          style: h3,
                        ),
                        content: Text('yay! your order placed successfully',textAlign:TextAlign.center,style:h5,),
                        actions: <Widget>[
                          CustomFlatButton(
                            text: 'OK',
                            onPress: () async {
                              product.clearCart();
                              await Navigator.of(context)
                                  .pushReplacementNamed(HomePage.routName);
                            },
                          )
                        ],
                      ));
            });
          })
        ],
      ),
    );
  }

  Widget buildPayemntCard({Function onPress}) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Payment Mode',
                style: h3,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomFlatButton(
                  onPress: onPress,
                  text: 'Cash on Delivery',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  var loading = false;

  Widget buildUserCard({address, userName}) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                address,
                style: h3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(userName, style: h5.copyWith(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(address, style: h5.copyWith(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomFlatButton(
                text: 'Change Address',
                onPress: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget singleCartItem(product) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Cart Summary',
                style: h3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Est. Total', style: h3),
                  Text(
                    'Rs $product',
                    style: h3.copyWith(color: Colors.green),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
