import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:things/style/colors.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _textFocusNode = new FocusNode ();

  @override
  void dispose() {
    this._textEditingController.dispose();
    this._titleEditingController.dispose();

    this._textFocusNode.dispose();

    super.dispose();
  }

  Future <bool> _confirmDelete() async {
    // show confirm dialog
    Future <bool> retval = new Future.value(false);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Are you sure?', 
          style: const TextStyle(color: mainRed, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text (
              'This action will delete the current note',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    retval = Future.value(false);
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text ('Okay', style: const TextStyle(color: mainRed, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    retval = Future.value(true);
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )
          ],
        ),
      )
    );

    return retval;
  }

  // Prevent route from poping
  Future <bool> _onWillPop() async {
    return await _confirmDelete();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: this._onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Column(
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
                      _confirmDelete().then((value) {
                        if (value) Navigator.pop(context);
                      });
                    },
                  ),
                ),

                // title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: this._titleEditingController,
                    maxLength: 128,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 36,
                      color: mainDarkBlue,
                      fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      hintText: 'Title', border: InputBorder.none
                    ),
                    onSubmitted: (value) {
                      // note.title = value;
                    },
                    onChanged: (value) {
                      // note.title = value;
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(
                        this._textFocusNode
                      );
                    },
                  ),
                ),

                // description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: TextField(
                    focusNode: this._textFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    controller: this._textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLength: 512,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 24, 
                      color: Colors.black87
                    ),
                    decoration: InputDecoration(
                      hintText: 'Description', border: InputBorder.none
                    ),
                    onSubmitted: (value) {
                      // note.text = value;
                    },
                    onChanged: (value) {
                      // note.text = value;
                    },
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // add to favorites / importants
                    IconButton(
                      // icon: Icon(
                      //     note.starred == 0 ? Icons.star_border : Icons.star,
                      //     color: myTheme.mainAccentColor),
                      icon: Icon(Icons.star_border),
                      onPressed: () {
                        print('star!');
                      },
                    ),

                    // select label
                    IconButton(
                      icon: Icon(Icons.label_outline),
                      onPressed: () {
                        print('label!');
                      },
                    ),

                    // add
                    Container(
                      decoration: ShapeDecoration(
                        shape: CircleBorder (),
                        color: mainBlue
                      ),
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(
                          Icons.add,
                        ),
                        onPressed: () {
                          print('add!');
                        },
                      ),
                    ),

                    // clear
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        print('clear!');
                      },
                    ),

                    // delete
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print('delete!');
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}