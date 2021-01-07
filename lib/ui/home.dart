import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/ui/add_note.dart';
import 'package:notes_app/ui/login.dart';
import 'package:notes_app/ui/manage_note.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
var _isGst;

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState(useremail:useremail);
  final String useremail;
  final bool guest;

  Home({this.useremail,this.guest});
}

class _HomeState extends State<Home> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  List<Info> info=List();
  _HomeState( {this.useremail} );
  var _user;
  Query _query;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var c=getNamee();
    var pr=new ProgressDialog(context, showLogs: true, type: ProgressDialogType.Normal,isDismissible: false);
    pr.style(
        message: 'Please Wait..',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInCubic,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    Future.delayed(Duration(milliseconds: 800),()
    {
      //  pr.show();
      _query =
          database.reference().child("Notes").orderByChild("user").equalTo(
              _user.toString());
      _query.onChildAdded.listen(_onEntryAdded);

      // databaseReference.onChildChanged.listen(_onChanged);
    });
  }
  final String useremail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black,
      ),
      drawer: _drawerItems(),
      body: _bodycontent(),
    );
  }
  Widget _drawerItems()
  {
        return Drawer(
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: InkWell(
                      child: Text("Hello $useremail"),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    currentAccountPicture: InkWell(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_outline, color: Colors.black),
                      ),
                  )
                  )
                ],
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Add Note"),
                onTap: (){
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                        return  AddNote();
                      }));
                },
              ),
              ListTile(
                leading: Icon(Icons.subdirectory_arrow_left),
                title: Text("Logout"),
                onTap: (){
                  showDialog(context: context,
                      builder: ( BuildContext context ) {
                        return AlertDialog(
                          title: Text("Logout"),
                          content: Text("Logging You Out...."),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: ( ) => _signOut(),
                              child: Text("Ok",
                                style: TextStyle(
                                    color: Colors.black
                                ),),
                            )
                          ],
                        );
                      }
                  );
                },
              )
            ],
          ),
        );
  }
  _signOut( ) async {
    _firebaseAuth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("login_user", null);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: ( context ) => LoginScreen()),
          ( Route<dynamic> route ) => false,
    );
  }

  getNamee() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var  _getName=preferences.getString("login_user");
    _user=_getName;
  }
  void _onEntryAdded(Event event) {
    setState(() {
      info.add(Info.fromSnapshot(event.snapshot));
    });
  }

  _bodycontent() {
    return Column(
      children: <Widget>[
        Container(height: 15,),
        Flexible(
          flex: 0,
          child: Text(info.length==0?"No Notes Added":"Your Notes",style: TextStyle(
              fontSize: 30,
              fontFamily: String.fromCharCode(90),
              color: Colors.black45
          ),),
          fit: FlexFit.tight,
        ),
        Container(height: 20,),
        Flexible(child: Visibility(
            visible: _query==null?false:true,
            child: FirebaseAnimatedList(
              defaultChild: CircularProgressIndicator(),
              query: _query==null?null:_query ,
              itemBuilder: (_,DataSnapshot snapshot,Animation<double> animation,int index){
                return Container(
                  height: 90,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: ListTile(
                      dense: false,
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
                          var data=info[index];
                          return ManageNote(data.key.toString(),data.title,data.desc,data.createdAt,data.editedAt);
                        }));
                      },
                      leading: Icon(Icons.note,color: Colors.black,),
                      title:  _query==null?CircularProgressIndicator():Text('${info[index].title}'),
                      subtitle: _query==null?CircularProgressIndicator():Text('${info[index].desc}'),
                      trailing: IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: (){
                                  _onDelete(info[index].key);
                      }),
                    ),
                  ),
                );
              },
            )
        )
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

class Info{
  String key;
  String title;
  String desc;
  String createdAt;
  String editedAt;

  Info(this.title,this.desc,this.createdAt,this.editedAt);
  Info.fromSnapshot(DataSnapshot snapshot):key=snapshot.key,title=snapshot.value['title'],desc=snapshot.value['desc'],createdAt=snapshot.value['createdAt'],editedAt=snapshot.value['editedAt'];
}
