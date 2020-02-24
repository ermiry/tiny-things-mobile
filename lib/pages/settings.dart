import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/settings.dart';

import 'package:things/sidebar/navigation_bloc.dart';

import 'package:things/style/colors.dart';

class SettingsPage extends StatelessWidget with NavigationStates {

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('An error ocurred!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('Success!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  // FIXME:
  Future <void> _clearLocalData(BuildContext context) async {
    // try {
    //   await Provider.of<Transactions>(context, listen: false).clearTransactions();
    //   Navigator.of(context).pop();
    //   this._showSuccessDialog(context, 'Local data has been deleted!');
    // }

    // catch (error) {
    //   Navigator.of(context).pop();
    //   this._showErrorDialog(context, 'Failed to delete local data!');
    // }
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
              this._clearLocalData(context);
            },
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Settings> (
      builder: (ctx, settings, _) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                Center(
                  child: Text(
                    "Settings",
                    style: const TextStyle(
                      fontSize: 32,
                      color: mainBlue,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text ('General', style: new TextStyle(fontSize: 18, color: mainDarkBlue, fontWeight: FontWeight.bold)),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: mainDarkBlue
                    ))
                  ),
                  child: ListTile(
                    title: const Text ('Center add button'),
                    subtitle: const Text('Display the add transaction button in the center'),
                    trailing: Switch.adaptive (
                      activeColor: mainBlue,
                      value: settings.centerAddButton,
                      onChanged: (val) { 
                        settings.toggleCenterAddButton();
                      },)
                  ),
                ),

                new SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text ('Danger Zone', style: new TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: mainDarkBlue
                    ))
                  ),
                  child: ListTile(
                    title: const Text ('Enable cloud backup'),
                    subtitle: const Text('Backup your transactions in the cloud'),
                    trailing: Switch.adaptive (
                      activeColor: mainBlue,
                      value: settings.enableCloud,
                      onChanged: (val) { 
                        // FIXME:
                        // settings.toggleHistoryChart();
                      },)
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: mainDarkBlue
                    ))
                  ),
                  child: ListTile(
                    title: Text ('Delete cloud data', style: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    subtitle: const Text('Delete all the transactions and data saved in the cloud'),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: mainDarkBlue
                    ))
                  ),
                  child: ListTile(
                    title: Text ('Clear local data', style: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    subtitle: const Text('Clear all the transactions and data saved in this device'),
                    onTap: () => this._showConfirmDialog(context, "Delete all transactions and data saved on this device?"),
                  ),
                ),

                new SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              ],
            ),
          ),
        );
      },
    );
  }

}