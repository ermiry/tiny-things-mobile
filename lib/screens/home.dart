import 'package:flutter/material.dart';

import 'package:things/screens/note.dart';
import 'package:things/screens/categories.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/ui.dart';
import 'package:things/providers/things.dart';
// import 'package:things/providers/settings.dart';

import 'package:things/models/thing.dart';

import 'package:things/widgets/thing.dart';
import 'package:things/widgets/categories.dart';

import 'package:things/style/colors.dart';

class HomeScreen extends StatefulWidget {

  @override
  HomeScreenState createState() => new HomeScreenState();

}

class HomeScreenState extends State <HomeScreen> with SingleTickerProviderStateMixin {

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
        Container (
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              Consumer <UI> (
                builder: (ctx, ui, _) => Row (
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16.0),

                    ui.isDrawerOpen ? IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        // setState(() {
                        //   xOffset = 0;
                        //   yOffset = 0;
                        //   scaleFactor = 1;
                        //   isDrawerOpen = false;
                        // });
                      },
                    )

                    :

                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        if (!ui.isDrawerOpen) {
                          ui.openDrawer();
                        }
                      }
                    ),

                    const SizedBox(width: 20.0),

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
              
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 30.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: <Widget>[
              //       SizedBox(width: 20.0),
              //       Text(
              //         'Home',
              //         style: TextStyle(
              //           fontSize: 28.0,
              //           fontWeight: FontWeight.bold,
              //           color: Color(0xFF2F3446)
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

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
        ),

        Positioned(
          bottom: MediaQuery.of(context).size.width * 0.12 + 78,
          left: MediaQuery.of(context).size.width * 0.8,
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
          bottom: MediaQuery.of(context).size.width * 0.12,
          left: MediaQuery.of(context).size.width * 0.8,
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
                  MaterialPageRoute(
                    builder: (_) {
                      return ChangeNotifierProvider.value(
                        value: new Thing.empty(null, null, null),
                        child: new NoteScreen (null)
                      );
                    }
                  ),
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
            return ChangeNotifierProvider.value(
              value: todo[idx],
              child: new ThingItem (),
            );
          }
        );
      }
    );
  }

}

class _ImportantTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <Things> (
      builder: (ctx, things, _) {
        int selectedIdx = things.selectedCategoryIdx;
        List <Thing> progress = things.categories[selectedIdx].important();

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: progress.length,
          itemBuilder: (ctx, idx) {
            return ChangeNotifierProvider.value(
              value: progress[idx],
              child: new ThingItem (),
            );
          }
        );
      }
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
            return ChangeNotifierProvider.value(
              value: progress[idx],
              child: new ThingItem (),
            );
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
            return ChangeNotifierProvider.value(
              value: done[idx],
              child: new ThingItem (),
            );
          }
        );
      }
    );
  }

}