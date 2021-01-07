import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
class EditNote extends StatefulWidget {
  var title,desc,keye;
  var create,edit;
  @override
  _EditNoteState createState() => _EditNoteState(title,desc,keye,create,edit);
  EditNote(this.title,this.desc,this.keye,this.create,this.edit);
}
final _formkey = GlobalKey<FormState>();
class _EditNoteState extends State<EditNote> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  _EditNoteState(this.t,this.d,this.k,this.create,this.edit);
  var k,t,d;var id;
  var create,edit;
  var _title,_desc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title=TextEditingController(text: "");
    _desc=TextEditingController(text:"");

    Future.delayed(Duration(milliseconds: 200),()
    {
      setState(() {
        _title.text=t;
        _desc.text=d;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        backgroundColor: Colors.black,
      ),
      body: _bodyContent(),
    );
  }

  _bodyContent() {
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
                  child: Text("Edit Note",
                      style: GoogleFonts.aldrich(fontSize: 30,color: Colors.black)
                  ),
                ),],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 9.0, left: 9.0, top: 15),
          child: Container(
            height: 1.5,
            color: Colors.white,
          ),
        ),
        Form(key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 250,
                        child: TextFormField(
                          controller: _title,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: Container(
                    height: 100,
                    width: 250,
                    child: TextField(
                        keyboardType: TextInputType.multiline,
                        controller: _desc,
                        maxLines: null,
                        decoration: InputDecoration(labelText: "Description",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        textColor: Colors.white,
                        onPressed: ()async{
                          await getUser();
                          var now = new DateTime.now();
                          var edata={
                            "title":_title.text,
                            "desc":_desc.text,
                            "createdAt":create,
                            "editedAt":now.toString(),
                            "user":id
                          };
                          _editNote(edata);
                        },
                        child: Text("Save"),
                        color: Colors.black,

                      )
                    ],
                  ),
                )
              ],
            )
        )
      ],
    );
  }

  void _editNote(var edata) {
    database.reference().child("Notes").child(k).set(edata);
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Note Edited"),
            content: Text(""),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(useremail: null)),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text("Ok",
                  style: TextStyle(
                      color: Colors.black
                  ),),
              ),
            ],
          );
        }
    );
  }
  getUser()async {
    print("in get user");
    SharedPreferences preferences=await SharedPreferences.getInstance();
    id=preferences.getString("login_user");
    print(id);

  }
}
