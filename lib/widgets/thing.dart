import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/style/colors.dart';

class ThingItem extends StatefulWidget {

  final Thing thing;

  ThingItem (this.thing);

  @override
  _ThingItemState createState() => new _ThingItemState();

}

class _ThingItemState extends State <ThingItem> {

  final DateFormat _dateFormatter = DateFormat('HH:mm - dd MMM');

  Widget _label(Label label) {
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

  void _reviewThing() {
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        Widget _deleteButton() {
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
                Navigator.of(bc).pop('delete');
              },
            ),
          );
        }

        Widget _importantButton() {
          return new Container(
            decoration: ShapeDecoration(
              shape: CircleBorder (),
              color: importantColor
            ),
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.star
              ),
              onPressed: () {
                // Navigator.of(context).pop();
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
                Icons.check
              ),
              onPressed: () {
                Navigator.of(context).pop('done');
              },
            ),
          );
        }

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
                      Text(
                        widget.thing.title,
                        style: TextStyle(
                          // color: Colors.black,
                          color: Color(0xFF2F3446),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),

                      this.widget.thing.description.isNotEmpty ? 
                        Column (
                          children: <Widget>[
                            SizedBox(height: 12.0),

                            // description
                            Text(
                              this.widget.thing.description,
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
                          itemCount: this.widget.thing.labels.length,
                          itemBuilder: (BuildContext context, int index) {
                            return this._label(this.widget.thing.labels[index]);
                          }
                        )
                      ),

                      SizedBox(height: 16.0),

                      // date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            _dateFormatter.format(widget.thing.date),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _deleteButton(),
                          _importantButton(),
                          _doneButton()
                        ],
                      )
                    ],
                  ),
                )
              ),
            ),
          ],
        );
      }
    ).then((value) {
      if (value == 'done') {
        Future.delayed(const Duration(milliseconds: 500), () {
          var things = Provider.of<Things>(context, listen: false);
          things.doneThing(
            things.categories[things.selectedCategoryIdx],
            this.widget.thing.id
          );
        });
      }

      else if (value == 'delete') {
        // 24/05/2020 - dirty way of avoiding an exception because the
        // parent widget gets destroyed before the modal bottom sheet's animation has finished
        Future.delayed(const Duration(milliseconds: 500), () {
          var things = Provider.of<Things>(context, listen: false);
          things.deleteThing(
            things.categories[things.selectedCategoryIdx],
            this.widget.thing.id
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  this.widget.thing.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),

                this.widget.thing.description.isNotEmpty ? 
                  Column (
                    children: <Widget>[
                      SizedBox(height: 12.0),

                      // description
                      Text(
                        this.widget.thing.description,
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
                        itemCount: this.widget.thing.labels.length,
                        itemBuilder: (BuildContext context, int index) {
                          return this._label(this.widget.thing.labels[index]);
                        }
                      )
                    ),

                    // date
                    Container(
                      width: MediaQuery.of(context).size.width * 0.36,
                      child: Text(
                        _dateFormatter.format(this.widget.thing.date),
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

          onTap: () => _reviewThing(),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }

}