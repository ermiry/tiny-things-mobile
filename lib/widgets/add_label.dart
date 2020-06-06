import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/models/label.dart';

// import 'package:pocket/widgets/custom/textfield.dart';
import 'package:things/widgets/custom/modal_action_button.dart';

import 'package:things/style/colors.dart';

class AddLabel extends StatefulWidget {

  final Label baseLabel;

  AddLabel (this.baseLabel);

  @override
  _AddLabelState createState() => _AddLabelState();

}

class _AddLabelState extends State <AddLabel> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  final _mainTextControler = new TextEditingController();
  final _subTextControler = new TextEditingController();

  final FocusNode _descriptionFocusNode = new FocusNode ();

  bool _start = true;
  bool _loading = false;

  int _selectedIdx = -1;
  List <Color> _colors = [
    Color.fromRGBO(22, 160, 133, 1),
    Color.fromRGBO(39, 174, 96, 1),
    Color.fromRGBO(41, 128, 185, 1),
    Color.fromRGBO(142, 68, 173, 1),
    Color.fromRGBO(44, 62, 80, 1),
    Color.fromRGBO(241, 196, 15, 1),
    Color.fromRGBO(230, 126, 34, 1),
    Color.fromRGBO(211, 84, 0, 1),
    Color.fromRGBO(231, 76, 60, 1),
    Color.fromRGBO(192, 57, 43, 1),
    Color.fromRGBO(189, 195, 199, 1),
    Color.fromRGBO(149, 165, 166, 1),
    Color.fromRGBO(127, 140, 141, 1),
  ];

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

  Future <void> _addLabel() async {
    try {
      var things = Provider.of<Things>(context, listen: false);

      await things.addLabel(
        things.categories[things.selectedCategoryIdx], 
        this._data['name'], 
        this._data['description'], 
        this._colors[this._selectedIdx]
      ).then((_) {
        FocusScope.of(context).requestFocus(FocusNode());
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Created new label!',
              textAlign: TextAlign.center,
            )
          )
        );
      });
    }

    catch (err) {
      print(err);
    }
  }

  Widget _label(int idx) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 8, bottom: 6),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: this._selectedIdx == idx ? Border.all(
            color: this._colors[idx],
            width: 8
          ) : null,
          color: this._selectedIdx != idx ? this._colors[idx] : null,
          borderRadius: BorderRadius.circular(6)
        ),
      ),
      onTap: () => {
        this.setState(() => this._selectedIdx = idx)
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this._start) {
      if (this.widget.baseLabel != null) {
        this._mainTextControler.text = this.widget.baseLabel.title;
        this._subTextControler.text = this.widget.baseLabel.description;
      }

      this.setState(() { this._start = false; });
    }

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
      padding: const EdgeInsets.all(24),
      child: new Form(
        key: this._formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                "Add label",
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
            ),

            const SizedBox(height: 16),

            Center(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemCount: this._colors.length,
                itemBuilder: (BuildContext context, int index) {
                  return this._label(index);
                }
              )
            ),

            const SizedBox(height: 16),

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
                    await this._addLabel();
                  }

                  catch (err) {
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