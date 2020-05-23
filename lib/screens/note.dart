import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    // color: myTheme.mainAccentColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: titleEditingController,
                  onSubmitted: (value) {
                    // note.title = value;
                  },
                  onChanged: (value) {
                    // note.title = value;
                  },
                  style: TextStyle(
                      // fontFamily: "BalooTamma2",
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      hintText: 'Add Title', border: InputBorder.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: textEditingController,
                  onSubmitted: (value) {
                    // note.text = value;
                  },
                  onChanged: (value) {
                    // note.text = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                  decoration: InputDecoration(
                      hintText: 'Add note', border: InputBorder.none),
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    // icon: Icon(
                    //     note.starred == 0 ? Icons.star_border : Icons.star,
                    //     color: myTheme.mainAccentColor),
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      // setState(() {
                      //   note.starred = note.starred == 0 ? 1 : 0;
                      // });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.label_outline),
                    onPressed: () {
                      // showCategories(context);
                    },
                  ),
                  Icon(
                    Icons.share,
                    // color: myTheme.mainAccentColor,
                  ),
                  Icon(
                    Icons.playlist_add_check,
                    // color: myTheme.mainAccentColor,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // databaseHelper.deleteNote(note.id);
                      // note.title = '';
                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}