import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';

// import 'package:pocket/widgets/adaptive/flatButton.dart';

class AddThing extends StatefulWidget {

  @override
  _AddThingState createState() => new _AddThingState ();

}

class _AddThingState extends State <AddThing> {

	final GlobalKey <FormState> _formKey = new GlobalKey <FormState> ();

  final FocusNode _descriptionFocusNode = new FocusNode ();

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
                          // FIXME:
                          // onSaved: (value) {
                          //   _authData['email'] = value;
                          // },
                        ),

                        new TextFormField (
                          // focusNode: this._passwordFocusNode,
                          decoration: const InputDecoration (labelText: 'Description'),
                          obscureText: true,
                          validator: (value) {
                            return null;
                          },
                          // FIXME:
                          // onSaved: (value) {
                          //   _authData['password'] = value;
                          // },
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
                      // FIXME: add new thing
                      Navigator.of (context).pop();
                  } 
                )
              ],
            )
		  		),
		  	),
		);

	}

}