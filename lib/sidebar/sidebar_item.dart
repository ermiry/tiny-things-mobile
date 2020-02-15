import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(16),
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
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
