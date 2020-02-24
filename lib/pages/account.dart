import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:things/sidebar/navigation_bloc.dart';

// import 'package:provider/provider.dart';
// import 'package:things/providers/auth.dart';

import 'package:things/style/colors.dart';
// import 'package:things/style/style.dart';

class AccountPage extends StatelessWidget with NavigationStates {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        Center(
          child: Text(
            "Your Account",
            style: const TextStyle(
              fontSize: 24,
              color: mainBlue,
              fontWeight: FontWeight.w800
            ),
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text ('General', style: new TextStyle(fontSize: 18, color: mainBlue, fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 10),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainDarkBlue.withAlpha(204)
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Avatar', style: new TextStyle(fontSize: 16)),
                    subtitle: Text('Change your avatar', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainDarkBlue.withAlpha(204)
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Name', style: new TextStyle(fontSize: 16)),
                    subtitle: Text('Erick Salas', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainDarkBlue.withAlpha(204)
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Username', style: new TextStyle(fontSize: 16)),
                    subtitle: Text('erick', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainDarkBlue.withAlpha(204)
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Email', style: new TextStyle(fontSize: 16)),
                    subtitle: Text('erick@test.com', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainDarkBlue.withAlpha(204)
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Password', style: new TextStyle(fontSize: 16)),
                    subtitle: Text('Change your password', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainDarkBlue.withAlpha(204)
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Member Since', style: new TextStyle(fontSize: 16)),
                    subtitle: Text(DateFormat ().format(DateTime.now()), style: new TextStyle(fontSize: 14),),
                  ),
                ),

                new SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text ('Danger Zone', style: new TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: Colors.red.withAlpha(204)
                    ))
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    leading: Icon(Icons.report_problem, color: Colors.red),
                    title: Text ('Delete account', style: new TextStyle(fontSize: 16, color: Colors.red)),
                    subtitle: const Text('Deleting your account is permanent. All your data will be wiped out immediately and you won\'t be able to get it back.'),
                  ),
                ),

                new SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

}