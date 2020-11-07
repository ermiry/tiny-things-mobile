import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/ui.dart';
import 'package:things/providers/auth.dart';

import 'package:things/style/colors.dart';

class DrawerScreen extends StatefulWidget {

  @override
  _DrawerScreenState createState() => _DrawerScreenState();

}

class _DrawerScreenState extends State <DrawerScreen> {

  void _showConfirmDialog(BuildContext context, String message) {
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
              message,
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
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    print('Logout!');
                    // Provider.of<Auth>(context, listen: false).logout();
                    // Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainBlue,
      padding: EdgeInsets.only(top: 48, left: 16),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // account info
          ListTile(
            title: Text(
              "${Provider.of<Auth>(context, listen: false).userValues['name']}",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              "${Provider.of<Auth>(context, listen: false).userValues['email']}",
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
            onTap: () => Provider.of<UI>(context, listen: false).changeScreen("Account"),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.1),

          Column(
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: [
                      Icon (Icons.home, color: Colors.white, size: 32),
                      const SizedBox (width: 20),
                      Text ("Home", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                    ],
                  ),
                ),
                onTap: () => Provider.of<UI>(context, listen: false).changeScreen("Home"),
              ),

              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: [
                      Icon (Icons.info, color: Colors.white, size: 32),
                      const SizedBox (width: 20),
                      Text ("About", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                    ],
                  ),
                ),
                onTap: () => Provider.of<UI>(context, listen: false).changeScreen("About"),
              )
            ],
          ),

          Spacer(),

          Row(
            children: [
              const Icon (Icons.settings, color: Colors.white),
              const SizedBox (width: 12),
              GestureDetector (
                child: const Text ('Settings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                onTap: () => Provider.of<UI>(context, listen: false).changeScreen("Settings"),
              ),
              const SizedBox (width: 12),

              Container (width: 2, height: 20, color: Colors.white),

              const SizedBox(width: 12),
              const Icon (Icons.logout, color: Colors.white),
              const SizedBox(width: 12),
              GestureDetector (
                child: const Text ('Log out', style: TextStyle (color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                onTap: () => this._showConfirmDialog(context, 'Are you sure you want to logout?'),
              )
            ]
          ),

          const SizedBox(height: 32),

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
          
          const SizedBox(height: 24)
        ],
      ),
    );
  }

}