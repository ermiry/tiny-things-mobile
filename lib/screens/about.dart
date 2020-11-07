import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/ui.dart';

import 'package:things/style/colors.dart';

import 'package:things/version.dart';

class AboutScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container (
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView (
        children: [
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
                  'About',
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

          new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Tiny Pocket Mobile App',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: mainDarkBlue),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'Version $version_number -- $version_date',
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'To learn more about Tiny Things,'
              ),
              const Text('check out the official website:'),
              const SizedBox(height: 10),
              const Text(
                'things.ermiry.com',
                style: TextStyle(color: mainDarkBlue),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Contact',
                style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'For any questions about our service,'
              ),
              const Text(
                'request information, or any other inquiry,'
              ),
              const Text(
                'please visit:'
              ),
              const SizedBox(height: 8),
              const Text(
                'ermiry.com/contact',
                style: TextStyle(color: mainDarkBlue),
              ),
              const SizedBox(height: 8),
              const Text(
                'or'
              ),
              const SizedBox(height: 8),
              const Text(
                'You can reach us directly here:'
              ),
              const SizedBox(height: 8),
              const Text(
                'contact@ermiry.com',
                style: TextStyle(color: mainDarkBlue),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Legal',
                style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'Privacy Policy'
              ),
              const SizedBox(height: 8),
              const Text(
                'ermiry.com/privacy-policy',
                style: TextStyle(color: mainDarkBlue),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Credits',
                style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 10),

              const Text(
                'Icon made by dmitri13 from',
              ),

              const Text('www.flaticon.com/authors/dmitri13'),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Copyright \u00a9 2020 Ermiry',
                style: TextStyle(color: mainBlue),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }

}