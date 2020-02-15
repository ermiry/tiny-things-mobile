import 'package:flutter/material.dart';

import 'package:things/sidebar/navigation_bloc.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/auth.dart';

import 'package:things/style/colors.dart';
import 'package:things/style/style.dart';

class AccountPage extends StatelessWidget with NavigationStates {

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),

                Center(
                  child: Text(
                    "Hello ${Provider.of<Auth>(context, listen: false).userValues['username']}!",
                    style: const TextStyle(
                      fontSize: 32,
                      color: mainBlue,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // hours played
                // Container(
                //   padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                //   child: Material(
                //     elevation: 4,
                //     borderRadius: const BorderRadius.all(Radius.circular(12)),
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           Row(
                //             children: <Widget>[
                //               Text(
                //                 "HOURS PLAYED",
                //                 style: hoursPlayedLabelTextStyle,
                //               ),
                //             ],
                //           ),
                //           SizedBox(
                //             height: 4,
                //           ),
                //           Text(
                //             "18 Hours",
                //             style: hoursPlayedTextStyle,
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 20),

                // info
                Container(
                  padding: const EdgeInsets.all(20),
                  child: new Material (
                    elevation: 4,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Padding (
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "YOUR INFO",
                            style: infoTitleTextStyle,
                          ),

                          const SizedBox(height: 16),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: <Widget>[
                          //     Column(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: <Widget>[
                          //         Text("Name", style: infoTextStyle),
                          //         SizedBox(height: 4),
                          //         Text("Erick", style: infoLabelTextStyle),
                                  
                          //       ],
                          //     ),

                          //     Column(
                          //       mainAxisAlignment: MainAxisAlignment.end,
                          //       children: <Widget>[
                          //         Text("Last Name", style: infoTextStyle),
                          //         SizedBox(height: 4),
                          //         Text("Salas", style: infoLabelTextStyle),
                                  
                          //       ],
                          //     ),
                          //   ]
                          // ),

                          Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text("Name", style: infoLabelTextStyle),
                                  SizedBox(height: 4),
                                  Text("${Provider.of<Auth>(context, listen: false).userValues['name']}", style: infoTextStyle),
                                ],
                              ),
                          ),

                          const SizedBox(height: 16),

                          Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text("Email", style: infoLabelTextStyle),
                                  SizedBox(height: 4),
                                  Text("${Provider.of<Auth>(context, listen: false).userValues['email']}", style: infoTextStyle),
                                ],
                              ),
                          ),

                          const SizedBox(height: 16),

                          // Center(
                          //   child: Column(children: <Widget>[
                          //     Text("Location", style: infoLabelTextStyle),
                          //     const SizedBox(height: 4,),
                          //     Text("Mexico City, Mexico", style: infoTextStyle),
                          //     const SizedBox(height: 16),

                          //     Text("Occupation", style: infoLabelTextStyle),
                          //     const SizedBox(height: 4,),
                          //     Text("Student", style: infoTextStyle),
                          //     const SizedBox(height: 16),
                          //   ])
                          // ),

                          // Divider(color: Colors.grey,)
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),

          // 12/02/2020 -- added to fill remaining screen and to avoid bug with sidebar
          Expanded (child: Container (),)
        ],
      ),
    );
  }

}