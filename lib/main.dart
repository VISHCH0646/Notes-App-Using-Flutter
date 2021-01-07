import 'package:flutter/material.dart';
import 'package:notes_app/ui/home.dart';
import 'package:notes_app/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';



void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  String type;
  String user;
  SharedPreferences preferences=await SharedPreferences.getInstance();
  if(preferences.getString("login_user")!=null&&preferences.getString("login_user").isNotEmpty  ){
    type="user";
    user=preferences.getString("login_user");
  }
  else
  {
    type=null;
    user=null;
  }
   Hello() {
   if (type == "user") {
       return Home(useremail: user,);
     }
     else {
       return LoginScreen();
     }
   }

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title:"Pg Finder",
    home:SplashScreen(
        seconds: 3,
        navigateAfterSeconds:Hello(),//yes==false?LoginScreen():Home(useremail: user),
        title: Text("Notes",style: GoogleFonts.aldrich(fontSize: 20,color: Colors.white)),
        //image:  Image.asset('icon/logo.png',height: 180,width: 180,color: Colors.white,),
        backgroundColor: Colors.black,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.white
    ),
  ));




}

// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'NotesApp',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Notes'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notes App"),
//         backgroundColor: Colors.black,
//       ),
//     );
//   }
// }
