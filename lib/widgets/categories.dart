import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/widgets/change_value.dart';

import 'package:things/style/colors.dart';

class CategoriesDisplay extends StatefulWidget {

  final bool add;

  CategoriesDisplay (this.add);

  @override
  _CategoriesDisplayState createState() => _CategoriesDisplayState();
  
}

class _CategoriesDisplayState extends State <CategoriesDisplay> {

  final Map <String, String> _data = {
    'name': '',
    'description': '',
  };

  String validateName(value) {
    if (value.isEmpty) return 'Name field is required!';
    return null;
  }

  void saveName(value) {
    this._data['name'] = value;
  }

  String validateDescription(value) {
    if (value.isEmpty) return 'Description field is required!';
    return null;
  }

  void saveDescription(value) {
    this._data['description'] = value;
  }

  Future <void> addCategory() async {
    try {
      // await Provider.of<Auth>(context, listen: false).changeName(
      //   this._data['name']
      // ).then((_) {
        FocusScope.of(context).requestFocus(FocusNode());
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Created new category!',
              textAlign: TextAlign.center,
            )
          )
        );
      // });
    }

    catch (err) {
      print(err);
    }
  }

  void _showNameChangeDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: new ChangeValue(
            title: "Add category", 

            placeholder: "Name",
            mainObscure: false,
            mainValidate: this.validateName,
            mainSave: this.saveName,

            subPlaceholder: "Description",
            subObscure: true,
            subValidate: this.validateDescription,
            subSave: this.saveDescription,

            callback: this.addCategory,
          )
        );
      }
    );
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
      onTap: () => this._showNameChangeDialog()
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