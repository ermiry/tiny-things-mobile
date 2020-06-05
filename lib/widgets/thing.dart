import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/models/thing.dart';
import 'package:things/models/label.dart';

import 'package:things/screens/note.dart';

import 'package:things/style/colors.dart';

class _LabelItem extends StatelessWidget {

  final Label label;

  _LabelItem (this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4, bottom: 4),
      // width: 24,
      // height: 24,
      decoration: BoxDecoration(
        color: label.color,
        borderRadius: BorderRadius.circular(6)
      ),
    );
  }

}

class ThingItem extends StatefulWidget {

  @override
  _ThingItemState createState() => new _ThingItemState();

}

class _ThingItemState extends State <ThingItem> {

  final DateFormat _dateFormatter = DateFormat('HH:mm - dd MMM');

  void _reviewThing(Thing thing) {
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return ChangeNotifierProvider.value(
          value: thing,
          child: new ReviewThing (),
        );
      }
    ).then((value) {
      // 24/05/2020 - dirty way of avoiding an exception because the
      // parent widget gets destroyed before the modal bottom sheet's animation has finished
      Future.delayed(const Duration(milliseconds: 500), () {
        var things = Provider.of<Things>(context, listen: false);

        if (value == 'todo') {
          things.setThingStatus(thing, 0);
        }

        else if (value == 'progress') {
          things.setThingStatus(thing, 1);
        }

        else if (value == 'done') {
          things.setThingStatus(thing, 2);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Thing> (
      builder: (ctx, thing, _) {
        return Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEFF4F6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          thing.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),

                        Icon(
                          thing.star ? Icons.star : Icons.star_border,
                          size: 24,
                        ),
                      ],
                    ),

                    thing.description.isNotEmpty ? 
                      Column (
                        children: <Widget>[
                          SizedBox(height: 12.0),

                          // description
                          Text(
                            thing.description,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )

                    :

                      Container (),

                    SizedBox(height: 16.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                            itemCount: thing.labels.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new _LabelItem(thing.labels[index]);
                            }
                          )
                        ),

                        // date
                        Container(
                          width: MediaQuery.of(context).size.width * 0.36,
                          child: Text(
                            _dateFormatter.format(thing.date),
                            style: TextStyle(
                              color: Color(0xFFAFB4C6),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              onTap: () => _reviewThing(thing),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        );
      }
    );
  }

}

class ReviewThing extends StatefulWidget {

  @override
  _ReviewThingState createState() => new _ReviewThingState();

}

class _ReviewThingState extends State <ReviewThing> {

  final DateFormat _dateFormatter = DateFormat('HH:mm - dd MMM');

  void deleteThing(Thing thing) {
     Future.delayed(const Duration(milliseconds: 500), () {
      var things = Provider.of<Things>(context, listen: false);
      things.deleteThing(
        things.categories[things.selectedCategoryIdx],
        thing.id
      );
    });
  }

  void _confirmDelete(Thing thing) {
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
              'Do you want to delete this thing?',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () async {
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
        Navigator.of(context).pop();
        deleteThing(thing);
      }
    });
  }

  Widget _deleteButton(Thing thing) {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: deleteColor
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.delete,
        ),
        onPressed: () {
          this._confirmDelete(thing);
        },
      ),
    );
  }

  Widget _editButton(Thing thing) {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: mainBlue
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.edit,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new NoteScreen (thing)),
          ).then((value) {
            if (value != null) {
              if (value == 'delete') {
                Navigator.of(context).pop();
                deleteThing(thing);
              }
            }
          });
        },
      ),
    );
  }

  Widget _progressButton() {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: importantColor
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.forward
        ),
        onPressed: () {
          Navigator.of(context).pop('progress');
        },
      ),
    );
  }

  Widget _doneButton() {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: doneColor
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.done
        ),
        onPressed: () {
          Navigator.of(context).pop('done');
        },
      ),
    );
  }

  Widget _todoButton() {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: mainBlue
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.arrow_back
        ),
        onPressed: () {
          Navigator.of(context).pop('todo');
        },
      ),
    );
  }

  Widget _todoButtonRow(Thing thing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _deleteButton(thing),
        _editButton(thing),
        _progressButton(),
        _doneButton()
      ],
    );
  }

  Widget _progressButtonRow(Thing thing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _deleteButton(thing),
        _editButton(thing),
        _doneButton()
      ],
    );
  }

  Widget _doneButtonRow(Thing thing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _deleteButton(thing),
        _editButton(thing),
        _progressButton(),
        _todoButton()
      ],
    );
  }

  Widget _buttonRow(Thing thing) {
    Widget retval = Container ();
    switch (thing.status) {
      case 0: retval = _todoButtonRow(thing); break;
      case 1: retval = _progressButtonRow(thing); break;
      case 2: retval = _doneButtonRow(thing); break;

      default: break;
    }

    return retval;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Thing> (
      builder: (ctx, thing, _) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // height: 300.0,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  color: Color(0xFFEFF4F6),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container (
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            thing.title,
                            style: TextStyle(
                              // color: Colors.black,
                              color: Color(0xFF2F3446),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),

                          IconButton(
                            color: mainBlue,
                            icon: Icon(
                              thing.star ? Icons.star : Icons.star_border,
                              size: 32,
                            ),
                            onPressed: () {
                              thing.toggleStar();
                            },
                          ),
                        ],
                      ),

                      thing.description.isNotEmpty ? 
                        Column (
                          children: <Widget>[
                            SizedBox(height: 12.0),

                            // description
                            Text(
                              thing.description,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )

                      :

                        Container (),

                      SizedBox(height: 24.0),

                      // labels
                      Container(
                        width: MediaQuery.of(context).size.width * 0.64,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                          itemCount: thing.labels.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new _LabelItem(thing.labels[index]);
                          }
                        )
                      ),

                      SizedBox(height: 16.0),

                      // date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            _dateFormatter.format(thing.date),
                            style: TextStyle(
                              color: Color(0xFFAFB4C6),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // buttons
                      SizedBox(height: 24.0),

                      _buttonRow(thing)
                    ],
                  ),
                )
              ),
            ),
          ],
        );
      }
    );
  }

}