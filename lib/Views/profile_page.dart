import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/order.dart';
import 'package:flutter_grocerry_app/Widgets/appBar.dart';
import 'package:flutter_grocerry_app/Widgets/colors.dart';
import 'package:flutter_grocerry_app/Widgets/neumorphicContainer.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  static final String routName='/Profilepage';
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthUser>(context);
     return Scaffold(
       appBar: AppBar(
         centerTitle:true,
         title:Text('Grocery',style:GoogleFonts.vt323(letterSpacing:12.0,fontSize:26),),
       ),
       drawer:AppBarDrawer(),
       body: Container(
         child:Center(child:Text('Nothing to Show! Currently in Progress',textAlign:TextAlign.center,style:GoogleFonts.monoton(fontSize:24),),),
       ),
     );
//    return StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance
//            .collection('orders')
//            .where('customerId', isEqualTo: user.userId)
//            .snapshots(),
//        builder: (context, AsyncSnapshot snapshot) {
//          if (snapshot.connectionState == ConnectionState.waiting) {
//            return SizedBox();
//          }
//          return !(snapshot.hasData)
//              ? Center(
//            child: CircularProgressIndicator(),
//          )
//              : Container(
//            margin: EdgeInsets.all(10),
//            child: ListView(
//              children: [
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    user.userName,
//                    textAlign: TextAlign.center,
//                    style: h3.copyWith(fontSize: 20),
//                  ),
//                ),
//                buildCustomCard('Phone no', user.phoneNo.toString()),
//                buildDivider(),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text('Delievry Address',
//                      style: h3.copyWith(fontSize: 17)),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    user.userAddress,
//                    style: h5,
//                    softWrap: true,
//                  ),
//                ),
//                buildDivider(),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: CustomFlatButton(
//                    text: 'Change Address',
//                    onPress: () {},
//                  ),
//                ),
//
//              ],
//            ),
//          );
//        });
  }

  buildCustomCard(title, name) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(title, style: priceText.copyWith(fontSize: 17)),
          Text(
            name,
            style: priceText.copyWith(color: Colors.green, fontSize: 17),
          ),
        ],
      ),
    );
  }

  buildDivider() {
    return Divider(
      thickness: 1.0,
      color: darkText,
    );
  }

  buildSingleOrderCard(Order order) {
    return Container(
      decoration:BoxDecoration(
        border:Border.all(
          color:Colors.black,
          width:1
        )
      ),
      child: NeumorphicContainer(
        bevel: 0,
        color: white,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    order.customerName,
                    style: h3.copyWith(color: Colors.black54, fontSize: 14),
                  ),
                  Text(
                    'Price: ' + order.totalPrice.toString(),
                    style: priceText,
                  ),
                  Text(
                    'Booked: ' +
                        readTimestamp(order.orderDate.millisecondsSinceEpoch),
                    style: priceText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSingleOrder(title, QuerySnapshot orders) {
    List<Order> lastOrder = List<Order>();
    for (var ord in orders.documents) {
      var temp = Order.fromMap(ord.data);
      if (temp.status == Order.BOOKED) {
        lastOrder.add(temp);
      }
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            style: h3.copyWith(color: Colors.black54),
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(
            lastOrder.length,
            (index) => Container(margin:EdgeInsets.symmetric(horizontal:10,vertical:10),child:buildSingleOrderCard(lastOrder[index]),),
          ),
        )
      ],
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }
    return time;
  }
}
