import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/home.dart';
import 'home.dart';
import 'signIn.dart';
import 'signUp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: SignInPage(),
      routes: <String, WidgetBuilder>{
        "/SignIn": (BuildContext context) => SignInPage(),
        "/SignUp": (BuildContext context) => SignUpPage(),
       // "/Home": (BuildContext context) => HomePage(),
      },
    );
  }
}
