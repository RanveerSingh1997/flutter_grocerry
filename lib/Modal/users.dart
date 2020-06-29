import 'package:flutter/cupertino.dart';

class User {
  String name;
  int number;
  String address;
  List orders;

  User({@required this.name, this.number, this.address, this.orders});

  static User fromMap(Map<String, dynamic> data) {
    return User(
        name: data['name'],
        number: data['number'],
        address: data['address'],
        orders: data['orders']);
  }

  static Map<String, dynamic> fromUser(User user) {
    return {
      'name': user.name,
      'address': user.address,
      'number': user.number,
      'orders': user.orders
    };
  }
}
