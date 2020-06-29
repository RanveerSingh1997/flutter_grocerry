import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Views/screens/selectedcategory.dart';
import 'package:flutter_grocerry_app/Widgets/customWidgets.dart';

class AllCategories extends StatelessWidget {
  final List<DocumentSnapshot> allCategory;

  AllCategories(this.allCategory);

  static final String routName = '/AllCategories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Categories'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.only(top: 20.0),
        itemCount: allCategory.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20
        ),
        itemBuilder: (context, index) {
          return FittedBox(
            child: headerCategoryItem(
              allCategory[index]['name'],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=>
                    SelectedCategory(allCategory[index]['name'])
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
