import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

import 'package:things/providers/things.dart';

// import 'package:pocket/widgets/adaptive/flatButton.dart';

class AddThing extends StatefulWidget {

  @override
  _AddThingState createState() => new _AddThingState ();

}

class _AddThingState extends State <AddThing> {

	final GlobalKey <FormState> _formKey = new GlobalKey ();

  final FocusNode _descriptionFocusNode = new FocusNode ();

  Map <String, String> _data = {
    'title': '',
    'description': ''
  };

  @override
  void dispose()  {
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  void _addThing() {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      Provider.of<Things>(context).addThing(this._data['title'], this._data['description']);
      Navigator.of (context).pop();
    }
  }

	@override
	Widget build (BuildContext context) {

		return SingleChildScrollView (
		  child: Card (
		  		elevation: 5,
		  		child: Container (
		  			padding: EdgeInsets.only(
            top: 10, 
            left: 10, 
            right: 10, 
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
		  			child: new Column (
              children: <Widget>[
                new Form (
                  key: this._formKey,
                  child: SingleChildScrollView (
                    child: Column (
                      children: <Widget>[
                        new TextFormField (
                          decoration: const InputDecoration (labelText: 'Title'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) return 'Title field is required!';
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(
                              this._descriptionFocusNode
                            );
                          },
                          onSaved: (value) {
                            this._data['title'] = value;
                          },
                        ),

                        new TextFormField (
                          focusNode: this._descriptionFocusNode,
                          decoration: const InputDecoration (labelText: 'Description'),
                          obscureText: true,
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {
                            if (value.isNotEmpty)
                              this._data['description'] = value;
                          },
                        ),
                      ]
                    )
                  )
                ),

                RaisedButton (
                  color: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.accent,
                    child: Text ('Add', style: TextStyle (color: Colors.white)),
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: () {
                      this._addThing();
                      // Navigator.of (context).pop();
                  } 
                )
              ],
            )
		  		),
		  	),
		);

	}

}