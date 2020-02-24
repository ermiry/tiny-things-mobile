import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/auth.dart';

import 'package:things/sidebar/navigation_bloc.dart';

import 'package:things/style/colors.dart';

class SidebarItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final Function onTap;

  const SidebarItem({Key key, this.icon, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class SideBar extends StatefulWidget {

  @override
  _SideBarState createState() => _SideBarState();

}

class _SideBarState extends State <SideBar> with SingleTickerProviderStateMixin <SideBar> {

  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  void _showConfirmDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('Are you sure?', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : - screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 35,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: mainBlue,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                      // account info
                      ListTile(
                        title: Text(
                          // "${Provider.of<Auth>(context, listen: false).userValues['name']}",
                          "Erick Salas",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          // "${Provider.of<Auth>(context, listen: false).userValues['email']}",
                          "erick@test.com",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFEFF4F6),
                          child: Icon(
                            Icons.perm_identity,
                            color: mainBlue,
                          ),
                          radius: 40,
                        ),
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.AccountPageClickedEvent);
                        },
                      ),

                      Divider(
                        height: 32,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 24,
                        endIndent: 24,
                      ),

                      // main routes
                      SidebarItem(
                        icon: Icons.home,
                        title: "Home",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                        },
                      ),

                      Spacer(),

                      Divider(
                        height: 32,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 24,
                        endIndent: 24,
                      ),

                      // suport routes
                      SidebarItem(
                        icon: Icons.info,
                        title: "About",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.AboutPageClickedEvent);
                        },
                      ),

                      SidebarItem(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.SettingsPageClickedEvent);
                        },
                      ),

                      SidebarItem(
                        icon: Icons.exit_to_app,
                        title: "Logout",
                        onTap: () => this._showConfirmDialog(context, 'Are you sure you want to logout?')
                      ),

                      SizedBox(height: 20),
                      Center(
                        child: new Text(
                          // "Copyright \u00a9 2020 Ermiry",
                          "Created by Ermiry",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        )
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.9),
                child: new GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: new ClipPath(
                    clipper: new CustomMenuClipper(),
                    child: new Container(
                      width: 35,
                      height: 110,
                      color: mainBlue,
                      alignment: Alignment.centerLeft,
                      child: new AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper <Path> {

  @override
  Path getClip(Size size) {
    // Paint paint = Paint();
    // paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}