import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/models/label.dart';

import 'package:things/widgets/categories.dart';
import 'package:things/widgets/add_label.dart';

import 'package:things/style/colors.dart';

class CategoriesScreen extends StatefulWidget {

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();

}

class _CategoriesScreenState extends State <CategoriesScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey <ScaffoldState>();

  void _addLabelDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: new AddLabel()
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: mainDarkBlue,
                      size: 36,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3446)
                    ),
                  )
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                new CategoriesDisplay (true),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                Consumer <Things> (
                  builder: (ctx, things, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F3446)
                            ),
                            textAlign: TextAlign.start,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            things.categories[things.selectedCategoryIdx].description,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    );
                  }
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Labels',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3446)
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),

                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                Consumer <Things> (
                  builder: (ctx, things, _) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: things.categories[things.selectedCategoryIdx].labels.length,
                      itemBuilder: (ctx, i) => LabelItem(things.categories[things.selectedCategoryIdx].labels[i])
                    );
                  }
                ),
              ],
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.05,
            left: MediaQuery.of(context).size.width * 0.83,
            child: Container(
              decoration: ShapeDecoration(
                shape: CircleBorder (),
                color: mainBlue
              ),
              child: IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.white,
                icon: Icon(Icons.label),
                onPressed: this._addLabelDialog,
                iconSize: 42
              )
            ),
          ),
        ],
      ),
    );
  }

}

class LabelItem extends StatelessWidget {

  final Label label;

  LabelItem (this.label);

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      key: ValueKey (label.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        var things = Provider.of<Things>(context, listen: false);
        things.deleteLabel(
          things.categories[things.selectedCategoryIdx],
          label.id
        );
      },
      confirmDismiss: (dir) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog (
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
            title: Text (
              'Are you sure?', 
              style: const TextStyle(color: mainDarkBlue, fontSize: 28),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text (
                  'Do you want to delete this label?',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                    FlatButton(
                      child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    )
                  ],
                )
              ],
            ),
          )
        );
      },
      background: Container (
        color: Theme.of(context).errorColor,
        child: Icon (
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 32),
        leading: Container(
          margin: EdgeInsets.only(right: 4, bottom: 4),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: label.color,
            borderRadius: BorderRadius.circular(6)
          ),
        ),
        title: new Text(
          label.title,
          style: const TextStyle(
            // color: Colors.black,
            color: Color(0xFF2F3446),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text(
          label.description,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          Provider.of<Things>(context, listen: false).countLabelThings(label).toString(),
          style: const TextStyle(
            color: Color(0xFF0F1426),
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    );
  }

}