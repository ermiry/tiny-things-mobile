import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:things/sidebar/navigation_bloc.dart';

import 'package:things/screens/note.dart';

import 'package:things/models/thing.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/settings.dart';

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

  int _selectedCategoryIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  Widget _buildCategoryCard(int index, String title, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        height: 240.0,
        width: 160.0,
        decoration: BoxDecoration(
          color: _selectedCategoryIndex == index
            ? mainBlue
            : Color(0xFFEFF4F6),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            _selectedCategoryIndex == index
              ? BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 10.0
                )
              : BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                title,
                style: TextStyle(
                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Color(0xFFAFB4C6),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      // : Colors.black,
                      : Color(0xFF0F1426),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

            Container(
              height: 260.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SizedBox(width: 8);
                  }
                  return _buildCategoryCard(
                    index - 1,
                    categories.keys.toList()[index - 1],
                    categories.values.toList()[index - 1],
                  );
                },
              ),
            ),

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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Important',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 18,
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
              onPressed: () => print('Review categories'),
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

class _ThingItem extends StatefulWidget {

  @override
  _ThingState createState() => new _ThingState();

}

class _ThingState extends State <_ThingItem> {

  final DateFormat _dateFormatter = DateFormat('hh:mm - dd MMM');

  void _reviewThing() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container ()
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Color(0xFFEFF4F6),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: <Widget>[
            // title
            Text(
              things[0].title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12.0),

            // description
            Text(
              things[0].content,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            // date
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  _dateFormatter.format(things[0].date),
                  style: TextStyle(
                    color: Color(0xFFAFB4C6),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      onTap: () => _reviewThing(),
    );
  }

}

class _ThingsTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        _ThingItem(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        _ThingItem(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        _ThingItem(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        _ThingItem(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
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

class _CompletedTab extends StatelessWidget {

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