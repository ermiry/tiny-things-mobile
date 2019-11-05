import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:things/providers/things.dart';

import 'package:things/widgets/add.dart';

class HomeScreen extends StatelessWidget {

  static const routename = '/home';

  @override
  Widget build(BuildContext context) {

    return Scaffold (
      appBar: AppBar (
        title: const Text ('Tiny Things'),
        actions: <Widget>[
          IconButton (
						icon: Icon (Icons.add),
						onPressed: () {
							showModalBottomSheet(
								context: context, 
								builder: (bCtx) { return new AddThing (); }
							);
						},
					)
        ],
      ),
      // drawer: AppDrawer (),
      body: Consumer <Things> (
        builder: (ctx, things, child) => ListView.builder(
          itemCount: things.things.length,
          itemBuilder: (ctx, idx) => new _ThingItem (things.things[idx])
        ),
      )
    );

  }

}

class _ThingItem extends StatelessWidget {

  final Thing thing;

  _ThingItem (this.thing);

  @override
  Widget build(BuildContext context) {

    return Column (
      children: <Widget>[
        Dismissible (
          key: ValueKey (this.thing.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            Provider.of <Things> (context).removeThing(this.thing.id);
          },
          confirmDismiss: (dir) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog (
                title: Text ('Are you sure?'),
                content: Text ('Do you want to delete the thing?'),
                actions: <Widget>[
                  FlatButton (
                    child: Text ('No'),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  FlatButton (
                    child: Text ('Yes'),
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              )
            );
          },
          background: Container (
            color: Theme.of(context).errorColor,
            child: Icon (
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            // margin: EdgeInsets.symmetric(
            //   horizontal: 15,
            //   vertical: 4
            // )
          ),
          child: ListTile (
            title: Text (this.thing.title),
            subtitle: Text (this.thing.description),
            // trailing: IconButton (
            //   icon: Icon (Icons.more_horiz),
            //   onPressed: () {},
            // ),
          ),
          
        ),
        new Divider ()
      ],
    );

  }

}