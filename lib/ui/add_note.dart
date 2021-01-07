import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
ProgressDialog pr;
final _formkey = GlobalKey<FormState>();
class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  var _title,_desc;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
  var id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = new ProgressDialog(context,showLogs: true,type: ProgressDialogType.Normal,isDismissible: false);
    _title=TextEditingController(text: "");
    _desc=TextEditingController(text: "");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        backgroundColor: Colors.black,
      ),
      body: _content(),
    );
  }
  Widget _content()
  {
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
                  child: Text("Add Note",
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
                        onPressed: (){
                          _addNote();
                        },
                        child: Text("Add"),
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

  void _addNote()async {
    pr.show();
    await getUser();
    var now = new DateTime.now();
    print(now);
    var noteToAdd = {
      "title": _title.text,
      "desc": _desc.text,
      "user": id,
      "createdAt": now.toString(),
      "editedAt": now.toString()
    };

    database.reference().child("Notes").push().set(noteToAdd);
    Navigator.pop(context);
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Note Added"),
            content: Text("Continue to home"),
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
              )
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
