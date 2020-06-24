import 'package:flutter/material.dart';

import 'package:animated_dialog/AnimatedDialog.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/widgets/add_category.dart';

import 'package:things/style/colors.dart';

class CategoriesDisplay extends StatefulWidget {

  final bool add;

  CategoriesDisplay (this.add);

  @override
  _CategoriesDisplayState createState() => _CategoriesDisplayState();
  
}

class _CategoriesDisplayState extends State <CategoriesDisplay> {

  void _addCategoryDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return new AnimatedDialog(
          changeToDialog: true,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: new AddCategory(null)

        );

        // return Dialog(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(12))
        //   ),
        //   child: new AddCategory(null)
        // );
      }
    ).then((value) {
      if (value != null) {
        if (value == 'add') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Created a new category!',
                textAlign: TextAlign.center,
              )
            )
          );
        }
      }
    });
  }

  Widget _create() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          bottom: 16,
          right: 6,
          left: 16
        ),
        height: 240.0,
        width: 160.0,
        decoration: BoxDecoration(
          color: Color(0xFFEFF4F6),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: mainBlue,
            size: 84,
          ),
        ) 
      ),
      onTap: this._addCategoryDialog
    );
  }

  Widget _category(int index, double left, String title, int count) {
    int selectedIdx = Provider.of<Things>(context).selectedCategoryIdx;
    return GestureDetector(
      onTap: () {
        Provider.of<Things>(context).selectedCategoryIdx = index;
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          bottom: 16,
          right: 8,
          left: left
        ),
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
          // padding: EdgeInsets.symmetric(horizontal: 16),
          height: 240.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: this.widget.add ? things.categories.length + 1 : things.categories.length,
            itemBuilder: (BuildContext context, int index) {
              int idx = this.widget.add ? index - 1 : index;

              if (this.widget.add) {
                if (index == 0) {
                  return this._create();
                }
              }

              return this._category(
                idx,
                index == 0 ? 16 : 6,
                things.categories[idx].title,
                things.categories[idx].things.length
              );
            },
          ),
        );
      }
    );
  }

}