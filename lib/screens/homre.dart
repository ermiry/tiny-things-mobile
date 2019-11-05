import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:things/providers/things.dart';

class HomeScreen extends StatelessWidget {

  static const routename = '/home';

  @override
  Widget build(BuildContext context) {

    final things = Provider.of<Things>(context);

    return Scaffold (
      appBar: AppBar (
        title: const Text ('Tiny Things')
      ),
      // drawer: AppDrawer (),
      body: ListView.builder(
        itemCount: things.things.length,
        itemBuilder: (ctx, idx) => new _ThingItem (things.things[idx])
      )
    );

  }

}

class _ThingItem extends StatefulWidget {

  final Thing thing;

  _ThingItem (this.thing);

  @override
  _ThingItemState createState() => new _ThingItemState ();

}

class _ThingItemState extends State <_ThingItem> {

  // FIXME:
  // bool _expanded = false;

  @override
  Widget build(BuildContext context) {

    return Card (
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder (
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile (
        title: Text (this.widget.thing.title),
        subtitle: Text (this.widget.thing.description),
        trailing: IconButton (
          icon: Icon (Icons.more_horiz),
          onPressed: () {
            // Navigator.of(context).pushNamed('/project-devblog-post');
          },
        ),
      ),
    );

  }

}