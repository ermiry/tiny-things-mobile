import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/things.dart';

import 'package:things/models/label.dart';

import 'package:things/widgets/custom/button.dart';

import 'package:things/style/colors.dart';

class ChooseLabels extends StatefulWidget {

  @override
  _ChooseLabelsState createState() => _ChooseLabelsState();

}

class _ChooseLabelsState extends State <ChooseLabels> {

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
                itemBuilder: (ctx, i) {
                  bool selected = false;
                  for (var l in things.selectedLabels) {
                    if (l.id == things.categories[things.selectedCategoryIdx].labels[i].id) {
                      selected = true;
                    }
                  }

                  return new ChooseLabel(
                    things.categories[things.selectedCategoryIdx].labels[i],
                    selected
                  );
                }
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

class ChooseLabel extends StatefulWidget {

  final Label label;
  final bool selected;

  ChooseLabel (this.label, this.selected);

  @override
  _ChooseLabelState createState() => _ChooseLabelState();

}

class _ChooseLabelState extends State <ChooseLabel> {

  bool _first = true;
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    if (this._first) {
      this._selected = this.widget.selected;
      this._first = false;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      leading: Container(
        margin: EdgeInsets.only(right: 4, bottom: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: this.widget.label.color,
          borderRadius: BorderRadius.circular(6)
        ),
      ),
      title: new Text(
        this.widget.label.title,
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
            this.widget.label.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: IconButton (
        icon: Icon(
          this._selected ? Icons.check_circle : Icons.check_circle_outline,
          color: mainDarkBlue,
          size: 28,
        ),
        onPressed: () {
          this.setState(() {
            this._selected = !this._selected;
          });

          var things = Provider.of<Things>(context, listen: false);
          if (this._selected) {
            things.selectedLabels.add(this.widget.label);
          }

          else {
            things.selectedLabels.removeWhere((l) => l.id == this.widget.label.id);
          }
        },
      )
    );
  }

}