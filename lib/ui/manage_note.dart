import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/ui/edit_note.dart';

import 'home.dart';

class ManageNote extends StatefulWidget {
  var title, desc,createdAt,editedAt;
  String keye;
  @override
  _ManageNoteState createState() => _ManageNoteState(keye,title,desc,createdAt,editedAt);
  ManageNote(this.keye,this.title,this.desc,this.createdAt,this.editedAt);
}

class _ManageNoteState extends State<ManageNote> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  String keye;
  var title, desc,createdAt,editedAt;
  _ManageNoteState(this.keye,this.title,this.desc,this.createdAt,this.editedAt);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Manage Note"),
        backgroundColor: Colors.black,
      ),
      body: _bodycontent(),
    );
  }

  _bodycontent() {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 99),
                  child: Text("$title",
                      style: GoogleFonts.aldrich(fontSize: 30,color: Colors.black)
                  ),
                )

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 9.0, left: 9.0, top: 35),
              child: Container(
                height: 1.5,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:18.0, top: 28,bottom: 18),
                  child: Text("Description:",style: GoogleFonts.aldrich(fontSize: 18,color: Colors.black)),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("$desc",style: GoogleFonts.aldrich(fontSize: 15,color: Colors.blueGrey)),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0,top: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Created At: $createdAt",style: GoogleFonts.aldrich(fontSize: 15,color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0,top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Edited At: $editedAt",style: GoogleFonts.aldrich(fontSize: 15,color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0,left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.edit,color: Colors.black,), onPressed: (){
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                          return new EditNote(title,desc,keye,createdAt,editedAt);
                        }));
                  }),
                  Text("Edit Note",style: GoogleFonts.aldrich(fontSize: 15,color: Colors.blueGrey))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: (){
                    _onDelete(keye);
                  }),
                  Text("Delete Note",style: GoogleFonts.aldrich(fontSize: 15,color: Colors.blueGrey))
                ],
              ),
            )
          ],
        )
      ],
    );
  }
  void _onDelete(var keye) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Note will be Deleted"),
            content: Text("Are you Sure?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  database.reference().child("Notes").child(keye).set(null);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(useremail: null)),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text("Yes",
                  style: TextStyle(
                      color: Colors.black
                  ),),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No",
                  style: TextStyle(
                      color: Colors.black
                  ),),
              )
            ],
          );
        }
    );
  }
}
