import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'users.dart';

class CartItem {
  String id;
  String name;
  String price;
  int quantity;
  List imageUrl;
  String discount;

  CartItem(
      {this.id,
      this.name,
      this.price,
      this.quantity,
      this.imageUrl,
      this.discount});

  static CartItem fromMap(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
      imageUrl: data['imageUrl'],
      discount: data['discount'],
    );
  }

  static Map<String, dynamic> fromCart(CartItem item) {
    return {
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
      'imageUrl': item.imageUrl,
      'discount': item.discount,
    };
  }
}

class AuthUser extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _user, _phone;
  User _userdata;

  Future<void> getUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    _user ='kt7ov5YGUWa6J4Iwy5cXn3S5b652'; //currentUser.uid;
    _phone = '918107105190';//currentUser.phoneNumber;
    _userdata = User.fromMap(
        (await Firestore.instance.collection('users').document(_user).get())
            .data);
  }

  String get userName{
  return _userdata.name!=null?userdata.name:'ranveer';
  }

  String get userAddress{
    return userdata.address;
  }

  User get userdata {
    return _userdata;
  }

  get userId {
    return _user;
  }

  get phoneNo {
    return _phone;
  }

  Map<String, CartItem> _products = {};

  Map<String, CartItem> get products {
    return _products;
  }

    addProducts(CartItem product) async{
      _products.putIfAbsent(
      product.id,
      () => CartItem(
        id: product.id,
        name: product.name,
        price: product.price,
        quantity: product.quantity,
        imageUrl: product.imageUrl,
        discount: product.discount,
      ),
    );
      notifyListeners();
  }

  void addQuantity(id) {
    _products.update(id, (item)=>
      CartItem(
        id: item.id,
        name: item.name,
        price: item.price,
        imageUrl: item.imageUrl,
        discount: item.discount,
        quantity:item.quantity+1,
      )
    );
    notifyListeners();
  }

  void subtractQuantity(id) {
    _products.update(id, (item)=>
        CartItem(
            id: item.id,
            name: item.name,
            price: item.price,
            imageUrl: item.imageUrl,
            discount: item.discount,
            quantity:item.quantity-1,
        )
    );
     notifyListeners();
  }

  void removeItem(id){
    _products.remove(id);
    notifyListeners();
  }


  int get totalProducts {
    return _products.length;
  }

  int totalAmount() {
    int total = 0;
    _products.forEach((key, item) {
      total += int.parse(item.price)*item.quantity;
    });
    return total;
  }

  int totalDiscountAmount() {
    double total = 0;
    _products.forEach((key, item) {
      total += ((int.parse(item.price) *
              int.parse(item.discount.replaceAll('%', ''))) /
          100)*item.quantity;
    });
    return total.round();
  }

  int totalEstimatedAmount() {
    double total = 0;
    total += totalAmount() - totalDiscountAmount() + 50;
    return total.round();
  }

  void clearCart(){
    _products.clear();
    notifyListeners();
  }
}
