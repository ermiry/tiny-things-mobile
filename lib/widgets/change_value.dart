import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:pocket/widgets/custom/textfield.dart';
import 'package:things/widgets/custom/modal_action_button.dart';

import 'package:things/style/colors.dart';
// import 'package:pocket/style/style.dart';

class ChangeValue extends StatefulWidget {

  final String title;

  final String placeholder;
  final bool mainObscure;
  final FormFieldValidator <String> mainValidate;
  final FormFieldSetter <String> mainSave;

  String subPlaceholder;
  bool subObscure = false;
  FormFieldValidator <String> subValidate;
  FormFieldSetter <String> subSave;

  final Future <void> Function() callback;

  ChangeValue({
    @required this.title,

    @required this.placeholder,
    @required this.mainObscure,
    @required this.mainValidate,
    @required this.mainSave,

    this.subPlaceholder,
    this.subObscure,
    this.subValidate,
    this.subSave,

    @required this.callback
  });

  @override
  _ChangeValueState createState() => _ChangeValueState();

}

class _ChangeValueState extends State <ChangeValue> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  final _mainTextControler = new TextEditingController();
  final _subTextControler = new TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    this._mainTextControler.clear();
    this._subTextControler.clear();

    return this._loading ?
      Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Center(
          child: new CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(mainBlue),
          ),
        ),
      )
     : 
     Padding(
      padding: const EdgeInsets.all(24.0),
      child: new Form(
        key: this._formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: mainDarkBlue
                ),
              )
            ),

            const SizedBox(height: 24),

            // main input
            TextFormField(
              controller: this._mainTextControler,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                labelText: widget.placeholder
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              obscureText: this.widget.mainObscure,
              validator: this.widget.mainValidate,
              onSaved: this.widget.mainSave,
            ),
            
            const SizedBox(height: 24),

            widget.subPlaceholder != null ? 
            // CustomTextField(labelText: widget.secondPlaceholder, controller: _subTextControler) 
            TextFormField(
              controller: this._subTextControler,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                labelText: widget.subPlaceholder
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              obscureText: this.widget.subObscure,
              validator: this.widget.subValidate,
              onSaved: this.widget.subSave,
            )
            : Container (),

            SizedBox(height: widget.subPlaceholder != null ? 24 : 0),

            CustomModalActionButton(
              onClose: () {
                Navigator.of(context).pop();
              },
              onSave: () async {
                if (this._formKey.currentState.validate()) {
                  this._formKey.currentState.save();

                  bool fail = false;
                  setState(() => this._loading = true);
                  try {
                    await this.widget.callback();
                  }

                  catch (err) {
                    // FIXME:
                    // this._showErrorDialog('Failed to change value!');
                    fail = true;
                  }

                  finally { 
                    if (!fail) Navigator.of(context).pop();
                    setState(() => this._loading = false); 
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}