import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';
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

  Widget _label() {
    return Container(
      margin: EdgeInsets.only(right: 4, bottom: 4),
      // width: 24,
      // height: 24,
      decoration: BoxDecoration(
        color: mainBlue,
        borderRadius: BorderRadius.circular(6)
      ),
    );
  }

  Widget _button(Color color, IconData iconData) {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: color
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          iconData,
        ),
        onPressed: () {
          
        },
      ),
    );
  }

  void _reviewThing() {
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
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
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 8,
                          children: <Widget>[
                            this._label(),
                            this._label(),
                            this._label(),
                            this._label(),
                          ],
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
                          this._button(deleteColor, Icons.delete),
                          this._button(importantColor, Icons.star),
                          this._button(doneColor, Icons.check),
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
    );
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
                  style: TextStyle(
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
                        style: TextStyle(
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
                    // labels
                    Container(
                      width: MediaQuery.of(context).size.width * 0.46,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 8,
                        children: <Widget>[
                          this._label(),
                          this._label(),
                          this._label(),
                          this._label(),
                          this._label(),
                        ],
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