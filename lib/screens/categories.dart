import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:provider/provider.dart';
// import 'package:things/providers/things.dart';

import 'package:things/widgets/categories.dart';
import 'package:things/widgets/change_value.dart';

import 'package:things/style/colors.dart';

class CategoriesScreen extends StatefulWidget {

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();

}

class _CategoriesScreenState extends State <CategoriesScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey <ScaffoldState>();

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

  Future <void> _addLabel() async {
    try {
      // await Provider.of<Auth>(context, listen: false).changeName(
      //   this._data['name']
      // ).then((_) {
        FocusScope.of(context).requestFocus(FocusNode());
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Created new label!',
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

  void _addLabelDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: new ChangeValue(
            title: "Add label", 

            placeholder: "Name",
            mainObscure: false,
            mainValidate: this.validateName,
            mainSave: this.saveName,

            subPlaceholder: "Description",
            subObscure: true,
            subValidate: this.validateDescription,
            subSave: this.saveDescription,

            callback: this._addLabel,
          )
        );
      }
    );
  }

  Widget label() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      leading: Container(
        margin: EdgeInsets.only(right: 4, bottom: 4),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: mainBlue,
          borderRadius: BorderRadius.circular(6)
        ),
      ),
      title: new Text(
        'Testing',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: new Text(
        'Related to testing',
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        '0',
        style: const TextStyle(
          color: Color(0xFF0F1426),
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
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

                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: refris.length,
                //   itemBuilder: (ctx, i) => new _RefriItem (refris[i])
                // ),

                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    this.label(),
                    this.label(),
                    this.label(),
                    this.label(),
                  ],
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