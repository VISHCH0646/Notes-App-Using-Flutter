import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//final GoogleSignIn _googleSignIn=new GoogleSignIn();


//Submit button to be customized.........
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
class Data{
  String fname,lname,email,password;
}

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formkey = GlobalKey<FormState>();
  var _fname,_lname,_email,_password,_cpassword,_phone;
  bool already=false;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;

  //Data obj=new Data();
  void initState() {
    super.initState();
    _fname=new TextEditingController(text: "");
    _lname=new TextEditingController(text: "");
    _email=new TextEditingController(text: "");
    _password=new TextEditingController(text: "");
    _cpassword=new TextEditingController(text:"");
    _phone=new TextEditingController(text:"");

  }

  @override
  Widget build(BuildContext context) {

    Widget content;
    // var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;
    if(orientation==Orientation.portrait){
      content=ifPortrait();
    }
    else{
      content=Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: Icon(Icons.warning,size: 70,color: Colors.red.shade700,),
          ),
          Text("We do not Support LandScape mode as of now!!!",style: TextStyle(fontSize: 20),),
          Text("Please Switch to Portrait Mode",style: TextStyle(fontSize: 20),)
        ],
      ));
    }


    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Create Account"),
        backgroundColor: Colors.black,
      ),
      body: content,
    );
  }

  Widget ifPortrait() {
    return ListView(
        children:[ Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:17.0,bottom: 17.0),
                child: Text("Create Account",
                  style: TextStyle(
                      fontSize: 34
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Container(
                      height: 60,
                      width: 170,
                      child: TextField(
                        controller: _fname,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Enter First Name",labelText: "First Name",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 60,
                      width: 170,
                      child: TextField(
                        controller: _lname,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Enter Last Name",labelText: "Last Name",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),
                      ),
                    ),
                  )

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Enter Email Address",labelText: "Email Id",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 3.3),
                    errorText: _email.text==""?null:_validateEmail(_email.text),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                child: TextField(
                    controller: _phone,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(hintText: "Enter Contact Number",labelText: "Contact Number",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                      errorText: _password.text==""?null:_validatePassword(_password.text),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                child: TextField(
                    controller: _password,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter Password",labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                      errorText: _password.text==""?null:_validatePassword(_password.text),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                child: TextField(
                  controller: _cpassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Confirm Password",
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 3.3
                    ),
                    errorText: _cpassword.text==""?null:_validateConfirmPassowrd(_password.text,_cpassword.text),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: FlatButton(
                  textColor: Colors.white,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70,right: 70,top:15,bottom: 15),
                    child: Text("Create Account",style: TextStyle(fontSize: 15),),
                  ),
                  splashColor: Colors.black,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(9),),
                  onPressed: (){
                    //_createUser(_fname.text, _lname.text, _email.text, _password.text);
                    {
                      // _scaffoldKey.currentState.showSnackBar(
//                        new SnackBar(
//                          duration: new Duration(seconds: 4), content:
//                        new Row(
//                          children: <Widget>[
//                            new CircularProgressIndicator(),
//                            new Text(" Creating Account...")
//                          ],
//                        ),
//                        ));

                      _createUser(
                          _fname.text, _lname.text, _email.text, _password.text);
//                          .whenComplete(() {
//                            if (already==false){
//
//                        Navigator.of(context).pop();
//                            }
//                            else {
//                              _scaffoldKey.currentState.showSnackBar(
//                                  new SnackBar(content: Text(
//                                      "User Already Registered!! Please Login")));
//                            }
//                      }
                      // );

                    }
                  },
                ),
              )
            ],
          ),
        ),
        ]
    );
  }
//Refer this code action after creating account
  _createUser(String fname,String lname,String email,String password)async {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          duration: new Duration(seconds: 8), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text(" Creating Account...")
          ],
        ),
        ));
    FirebaseUser user;

    try {
      //_firebaseAuth.verifyPhoneNumber(phoneNumber: null, timeout: null, verificationCompleted: null, verificationFailed: null, codeSent: null, codeAutoRetrievalTimeout: null)
      user = (await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password).then((user) {
        print('Create User');
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("Account Created"),
                content: Text("Please Login"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
      }));
      var UserData={
        "fname":_fname.text,
        "lname":_lname.text,
        "name":_fname.text+"   "+_lname.text,
        "contact":_phone.text,
        "email":_email.text,
        "provider":"email"
      };
//      var keyd=_email.text;
//      for(var i=0;i<keyd.length;i++)
//        {
//          if(keyd[i]=='.')
//            {
//
//            }
//        }
      await _firebaseAuth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
      FirebaseUser tempUser=await _firebaseAuth.currentUser();
      ref=database.reference().child("users");
      ref.reference().child(tempUser.uid).set(UserData);
      _firebaseAuth.signOut();
    }catch(error){
      switch(error.code)
      {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: Text(
                  "User Already Registered!! Please Login")));
          break;
        case "ERROR_WEAK_PASSWORD":
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: Text(
                  "Password Should be Greater than 6 characters")));
          break;
        default:
          print(error.code);
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: Text(
                  "Something's Not Right.. Please Try Later")));
          break;

      }
    }



  }

  //for validation

//
  String _validateEmail(String em) {
    var email = em;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(emailValid==false)
    {
      return "Enter Valid Email Id";
    }
    else{
      return null;
    }

  }

  String _validatePassword(String passw) {
    if(passw.length<6)
    {
      return "Password Length Should be Greater then 6";
    }
    return null;
  }

  String _validateConfirmPassowrd(String passw,String cpassw) {
    if(passw!=cpassw)
    {
      return "Both the Passwords Should be Same";
    }
    return null;
  }

  String _validatePhone(String phone) {
    if(phone.length!=10){
      return "Number should be of 10 digits";
    }
    return null;
  }

}