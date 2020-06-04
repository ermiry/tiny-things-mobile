import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:things/sidebar/navigation_bloc.dart';

import 'package:things/screens/note.dart';
import 'package:things/screens/categories.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';
// import 'package:things/providers/settings.dart';

import 'package:things/widgets/thing.dart';
import 'package:things/widgets/categories.dart';

import 'package:things/style/colors.dart';

class HomePage extends StatelessWidget with NavigationStates {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _NotesScreen(),
    );
  }

}

class _NotesScreen extends StatefulWidget {

  @override
  _NotesScreenState createState() => new _NotesScreenState();

}

class _NotesScreenState extends State <_NotesScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: <Widget>[
        ListView(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 20.0),
                  Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3446)
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            new CategoriesDisplay (false),

            Center(
              child: TabBar(
                controller: _tabController,
                labelColor: Color(0xFF2F3446),
                unselectedLabelColor: Color(0xFFAFB4C6),
                indicatorColor: mainBlue,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 4.0,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Things',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Important',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'In Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0),

            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  _ThingsTab(),
                  _ImportantTab(),
                  _ProgressTab(),
                  _CompletedTab(),
                ],
              ),
            ),
          ],
        ),

        Positioned(
          bottom: MediaQuery.of(context).size.width * 0.05 + 78,
          left: MediaQuery.of(context).size.width * 0.83,
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder (),
              color: mainBlue
            ),
            child: IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.white,
              icon: Icon(Icons.category),
              iconSize: 42,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new CategoriesScreen ()),
                );
              },
            )
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).size.width * 0.05,
          left: MediaQuery.of(context).size.width * 0.83,
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder (),
              color: mainBlue
            ),
            child: IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.white,
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new NoteScreen ()),
                );
              },
              iconSize: 42
            )
          ),
        ),
      ],
    );
  }
}

class _ThingsTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <Things> (
      builder: (ctx, things, _) {
        int selectedIdx = things.selectedCategoryIdx;
        List <Thing> todo = things.categories[selectedIdx].todo();

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: todo.length,
          itemBuilder: (ctx, idx) {
            return ThingItem (todo[idx]);
          }
        );
      }
    );
  }

}

class _ImportantTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[

      ],
    );
  }

}

class _ProgressTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <Things> (
      builder: (ctx, things, _) {
        int selectedIdx = things.selectedCategoryIdx;
        List <Thing> progress = things.categories[selectedIdx].progress();

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: progress.length,
          itemBuilder: (ctx, idx) {
            return ThingItem (progress[idx]);
          }
        );
      }
    );
  }

}

class _CompletedTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <Things> (
      builder: (ctx, things, _) {
        int selectedIdx = things.selectedCategoryIdx;
        List <Thing> done = things.categories[selectedIdx].done();

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: done.length,
          itemBuilder: (ctx, idx) {
            return ThingItem (done[idx]);
          }
        );
      }
    );
  }

}