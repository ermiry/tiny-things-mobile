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
                  child: Text ('General', style: new TextStyle(fontSize: 18, color: mainDarkBlue, fontWeight: FontWeight.bold)),
                ),

                SizedBox(height: 10),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainBlue
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Avatar', style: new TextStyle(fontSize: 18)),
                    subtitle: Text('Change your avatar', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      // color: mainBlue.withAlpha(200)
                      color: mainBlue
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Name', style: new TextStyle(fontSize: 18)),
                    subtitle: Text('Erick Salas', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      // color: mainBlue.withAlpha(200)
                      color: mainBlue
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Username', style: new TextStyle(fontSize: 18)),
                    subtitle: Text('erick', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainBlue
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Email', style: new TextStyle(fontSize: 18)),
                    subtitle: Text('erick@test.com', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      width: 0.7,
                      color: mainBlue
                    ))
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text ('Password', style: new TextStyle(fontSize: 18)),
                    subtitle: Text('Change your password', style: new TextStyle(fontSize: 14),),
                  ),
                ),

                
              ],
            ),
          ),
        ),
      ],
    );
  }

}