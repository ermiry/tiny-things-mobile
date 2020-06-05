import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/widgets/choose_labels.dart';

import 'package:things/style/colors.dart';

class NoteScreen extends StatefulWidget {

  final Thing thing;

  NoteScreen(this.thing);

  @override
  _NoteScreenState createState() => _NoteScreenState();
  
}

class _NoteScreenState extends State <NoteScreen> {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _titleFocusNode = new FocusNode ();
  final FocusNode _textFocusNode = new FocusNode ();

  bool _start = true;
  bool _edit = false;
  bool _first = true;

  @override
  void dispose() {
    this._titleEditingController.dispose();
    this._textEditingController.dispose();

    this._titleFocusNode.dispose();
    this._textFocusNode.dispose();

    super.dispose();
  }

  Future <bool> _confirmExit(String description) async {
    // show confirm dialog
    return await showDialog(
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
              description,
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
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text ('Okay', style: const TextStyle(color: mainRed, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    this._titleEditingController.clear();
                    this._textEditingController.clear();

                    Navigator.of(ctx).pop(true);
                  },
                )
              ],
            )
          ],
        ),
      )
    );
  }

  // Prevent route from poping
  Future <bool> _onWillPop() async {
    if (this._titleEditingController.text.isNotEmpty ||
      this._textEditingController.text.isNotEmpty) {
      bool value = false;

      if (this.widget.thing != null) {
        if (this._edit) {
          value = await this._confirmExit('Changes to your current thing won\'t be saved');
        }

        else {
          value = true;
        }
      }

      else {
        value = await this._confirmExit('This action will delete the current note');
      }

      if (value) {
        FocusScope.of(context).requestFocus(FocusNode());
        return new Future.value(true);
      }

      else return new Future.value(false);
    }

    return new Future.value(true);
  }

  void _labelSelect() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: new ChooseLabels()
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

    if (this._start) {
      if (this.widget.thing != null) {
        this._titleEditingController.text = this.widget.thing.title;
        this._textEditingController.text = this.widget.thing.description;
      }

      this._start = false;
    }

    if (this._first) {
      FocusScope.of(context).requestFocus(this._titleFocusNode);
      this.setState(() => this._first = false);
    }

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
                      bool value = await this._onWillPop();
                      if (value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pop(context);
                      } 
                    },
                  ),
                ),

                // title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: TextField(
                    focusNode: this._titleFocusNode,
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
                      if (this.widget.thing != null) {
                        // this.setState(() { this._edit = true; });
                        this._edit = true;
                      }
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
                      if (this.widget.thing != null) {
                        // this.setState(() { this._edit = true; });
                        this._edit = true;
                      }
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
                      onPressed: this._labelSelect
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
                          this.widget.thing != null ? Icons.check : Icons.add,
                        ),
                        onPressed: () async {
                          var things = Provider.of<Things>(context, listen: false);

                          if (this.widget.thing != null) {
                            things.updateThing(
                              this.widget.thing, 
                              this._titleEditingController.text, 
                              this._textEditingController.text
                            );
                          }

                          else {
                            await things.addThing(
                              things.categories[things.selectedCategoryIdx],
                              this._titleEditingController.text, 
                              this._textEditingController.text
                            );
                          }

                          // return to home screen
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    // clear
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        if (this._textEditingController.text.isNotEmpty) {
                          this._textEditingController.clear();
                          if (this.widget.thing != null) {
                            // this.setState(() { this._edit = true; });
                            this._edit = true;
                          }
                        }
                      },
                    ),

                    // delete
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        if (this._titleEditingController.text.isNotEmpty ||
                          this._textEditingController.text.isNotEmpty) {
                          await this._confirmExit('This action will delete the current note');
                        }
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