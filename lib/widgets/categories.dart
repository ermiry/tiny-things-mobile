import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/style/colors.dart';

class CategoriesDisplay extends StatefulWidget {

  @override
  _CategoriesDisplayState createState() => _CategoriesDisplayState();
  
}

class _CategoriesDisplayState extends State <CategoriesDisplay> {

  Widget _buildCategoryCard(int index, String title, int count) {
    int selectedIdx = Provider.of<Things>(context).selectedCategoryIdx;
    return GestureDetector(
      onTap: () {
        Provider.of<Things>(context).selectedCategoryIdx = index;
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        height: 240.0,
        width: 160.0,
        decoration: BoxDecoration(
          color: selectedIdx == index
            ? mainBlue
            : Color(0xFFEFF4F6),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            selectedIdx == index
              ? BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 10.0
                )
              : BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                title,
                style: TextStyle(
                  color: selectedIdx == index
                      ? Colors.white
                      : Color(0xFFAFB4C6),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: selectedIdx == index
                      ? Colors.white
                      // : Colors.black,
                      : Color(0xFF0F1426),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Things> (
      builder: (ctx, things, _) {
        return Container(
          height: 240.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: things.categories.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return SizedBox(width: 8);
              }
              return _buildCategoryCard(
                index - 1,
                things.categories[index - 1].title,
                things.categories[index - 1].things.length
              );
            },
          ),
        );
      }
    );
  }

}