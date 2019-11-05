import 'package:flutter/material.dart';

import 'package:things/screens/done.dart';
import 'package:things/screens/home.dart';

class TabScreen extends StatefulWidget {

  @override
  _TabScreenState createState() => new _TabScreenState ();

}

class _TabScreenState extends State <TabScreen> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController (
      length: 2,
      child: Scaffold (
        appBar: AppBar (
          title: Text ('Things'),
          bottom: TabBar (
            tabs: <Widget>[
              Tab (
                icon: Icon (Icons.list),
                text: 'to-do',
              ),
              Tab (
                icon: Icon (Icons.done_all),
                text: 'completed',
              )
            ],
          ),
        ),
        body: TabBarView (
          children: <Widget>[
            new HomeScreen (),
            new DoneScreen ()
          ],
        ),
      ),
    );

  }

}