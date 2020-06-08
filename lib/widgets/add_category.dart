import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/models/category.dart';

import 'package:things/style/colors.dart';

class AddCategory extends StatefulWidget {

  final Category baseCategory;

  AddCategory (this.baseCategory);

  @override
  _AddCategoryState createState() => _AddCategoryState();

}

class _AddCategoryState extends State <AddCategory> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  final _mainTextControler = new TextEditingController();
  final _subTextControler = new TextEditingController();

  final FocusNode _descriptionFocusNode = new FocusNode ();

  bool _start = true;
  bool _edit = false;

  final Map <String, String> _data = {
    'name': '',
    'description': '',
  };

  @override
  void dispose() {
    this._mainTextControler.dispose();
    this._subTextControler.dispose();

    this._descriptionFocusNode.dispose();

    super.dispose();
  }

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

  Future <void> _addCategory() async {
    try {
      var things = Provider.of<Things>(context, listen: false);

      await things.addCategory(
        this._data['name'], 
        this._data['description'], 
      ).then((_) {
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }

    catch (err) {
      print(err);
    }
  }

  void _updateCategory() {
    try {
      var things = Provider.of<Things>(context, listen: false);
      things.updateCategory(
        this.widget.baseCategory,
        this._data['name'], 
        this._data['description'], 
      );

      FocusScope.of(context).requestFocus(FocusNode());
    }

    catch (err) {
      print(err);
    }
  }

  Future <void> _save() async {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();

      bool fail = false;
      String retval;
      try {
        if (this.widget.baseCategory != null) {
          retval = 'edit';
          this._updateCategory();
        }

        else {
          retval = 'add';
          await this._addCategory();
        }
      }

      catch (err) {
        fail = true;
      }

      finally { 
        if (!fail) Navigator.of(context).pop(retval);
      }
    }
  }

  void _confirmDelete() {
    showDialog(
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
              'This action will also delete all labels and things associated with this category',
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
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                )
              ],
            )
          ],
        ),
      )
    ).then((value) {
      if (value) {
        var things = Provider.of<Things>(context, listen: false);
        things.deleteCategory(
          things.categories[things.selectedCategoryIdx]
        );

        Navigator.of(context).pop('delete');
      }
    });
  }

  Widget _deleteButton() {
    if (this.widget.baseCategory != null) {
      return Column (
        children: <Widget>[
          const SizedBox(height: 8),

          new Container(
            height: 42,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: mainRed
            ),
            child: Center(
              child: RawMaterialButton(
                hoverColor: Colors.transparent,
                fillColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                elevation: 0,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800
                ),
                child: Text("Delete"),
                onPressed: this._confirmDelete,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      );
    }

    else {
      return Container ();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._start) {
      if (this.widget.baseCategory != null) {
        this._mainTextControler.text = this.widget.baseCategory.title;
        this._subTextControler.text = this.widget.baseCategory.description;
      }

      else {
        this._mainTextControler.clear();
        this._subTextControler.clear();
      }

      this.setState(() { this._start = false; });
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: new Form(
        key: this._formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                this.widget.baseCategory != null ? "Edit category" : "Add category",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: mainDarkBlue
                ),
              )
            ),

            const SizedBox(height: 16),

            // main input
            TextFormField(
              controller: this._mainTextControler,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                labelText: "Name"
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              obscureText: false,
              validator: this.validateName,
              onSaved: this.saveName,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(
                  this._descriptionFocusNode
                );
              },
              onChanged: (value) {
                this.setState(() => this._edit = true );
              },
            ),
            
            const SizedBox(height: 16),

            TextFormField(
              focusNode: this._descriptionFocusNode,
              controller: this._subTextControler,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                labelText: "Description"
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              obscureText: false,
              validator: this.validateDescription,
              onSaved: this.saveDescription,
              onChanged: (value) {
                this.setState(() => this._edit = true );
              },
            ),

            const SizedBox(height: 16),

            this._deleteButton(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // close
                MaterialButton(
                  child: Text("Close"),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  padding: const EdgeInsets.all(14.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                // save / edit
                MaterialButton(
                  child: Text(this.widget.baseCategory != null ? "Edit" : "Add"),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  color: mainBlue,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(14.0),
                  onPressed: this._edit ? this._save : null,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}