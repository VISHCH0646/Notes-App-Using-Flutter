import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notes_app/ui/create_account.dart';
import 'package:notes_app/ui/forgot_password.dart';
import 'package:notes_app/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _email, _password;


  void initState() {
    super.initState();
    _email = new TextEditingController(text: "");
    _password = new TextEditingController(text: "");
  }


  @override
  Widget build(BuildContext context) {
    Widget content;
    // var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery
        .of(context)
        .orientation;
    if (orientation == Orientation.portrait) {
      content = ifPortrait();
    }
    else {
      content = Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Icon(Icons.warning, size: 70, color: Colors.red.shade700,),
          ),
          Text("We do not Support LandScape mode as of now!!!",
            style: TextStyle(fontSize: 20),),
          Text(
            "Please Switch to Portrait Mode", style: TextStyle(fontSize: 20),)
        ],
      ));
    }


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign In Using Email"),
        backgroundColor: Colors.black,
      ),
      body: content,
    );
  }

  Widget ifPortrait() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 14.0, top: 28),
          child: Text("Sign In", style: TextStyle(
              fontSize: 40
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _email,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Enter Email", labelText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  gapPadding: 3.3),
              errorText: _email.text == "" ? null : _validateEmail(_email.text),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _password,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Enter Password", labelText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  gapPadding: 3.3),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 8.0, top: 8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[
        //       Text("Forgot Password? "),
        //       InkWell(
        //         child: Text("Click Here."),
        //         onTap: () {
        //           Navigator.of(context).push(
        //               new MaterialPageRoute(builder: (BuildContext context) {
        //                 return new ForgotPassword();
        //               }));
        //         },
        //       )
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FlatButton(
            textColor: Colors.white,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 70, right: 70, top: 15, bottom: 15),
              child: Text("Login", style: TextStyle(fontSize: 15),),
            ),
            splashColor: Colors.black,
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(9),),
            onPressed: () => _signinEmail(_email.text, _password.text),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 21.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("New User?"),
              InkWell(
                child: Text(" Register Here"),
                onTap: () {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                        return new CreateAccount();
                      }));
                },
              )
            ],
          ),
        )
      ],
    );
  }

  String _validateEmail(String em) {
    var email = em;
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid == false) {
      return "Enter Valid Email Id";
    }
    else {
      return null;
    }
  }

  _signinEmail(String email, String password) async {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          duration: new Duration(seconds: 8), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text(" Logging You In")
          ],
        ),
        ));

    try{
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password)
          .then((user) {
        final snackbar = SnackBar(content: Text("Welcome ${user.user.email}"));
        _scaffoldKey.currentState.showSnackBar(snackbar);

        _saveData(user.user.email.toString());

        //navigate to home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home(useremail: user.user.email,)),
              (Route<dynamic> route) => false,
        );
      });
    }catch(error){
      switch(error.code){
        case 'ERROR_USER_NOT_FOUND':
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: Text(
                  "Email Not Registered!!  Please Register")));
          break;

        case 'ERROR_WRONG_PASSWORD':
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: Text(
                  "Wrong Password for the Entered Email")));
          break;
      }
    }
  }

  void _saveData(String user)async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("login_user", user);
  }
}