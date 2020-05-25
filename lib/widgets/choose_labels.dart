import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/widgets/custom/button.dart';

import 'package:things/style/colors.dart';

class ChooseLabels extends StatefulWidget {

  @override
  _ChooseLabelsState createState() => _ChooseLabelsState();

}

class _ChooseLabelsState extends State <ChooseLabels> {

  Widget _label(Label label) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      leading: Container(
        margin: EdgeInsets.only(right: 4, bottom: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: label.color,
          borderRadius: BorderRadius.circular(6)
        ),
      ),
      title: new Text(
        label.title,
        style: const TextStyle(
          // color: Colors.black,
          color: Color(0xFF2F3446),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 4),

          new Text(
            label.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.check_circle_outline,
          color: mainDarkBlue,
          size: 28,
        ),
        onPressed: () {
          // FocusScope.of(context).requestFocus(FocusNode());
          // Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Things> (
      builder: (ctx, things, _) {
        return SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16),

              Center(
                child: Text(
                  "Choose label(s)",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: mainDarkBlue
                  ),
                )
              ),

              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: things.categories[things.selectedCategoryIdx].labels.length,
                itemBuilder: (ctx, i) => _label(things.categories[things.selectedCategoryIdx].labels[i])
              ),

              const SizedBox(height: 16),
              // Spacer(),

              CustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                buttonText: "Done",
                color: mainBlue,
                textColor: Colors.white,
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      }
    );
  }

}