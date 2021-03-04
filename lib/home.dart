import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SignIn");
      }
    });
  }

  getUser() {
    User user = _auth.currentUser; //get user
    user?.reload(); //reload user
    user = _auth.currentUser; //then provide current user
    if (user != null) {
      setState(() {
        this.user = user;
        this.isSignedIn = true;
      });
    }
    print(this.user);
  }

  void signOutUser() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase'),
      ),
      body: Center(
        child: !isSignedIn
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: CircleAvatar(
                      child: Text('DB'),
                      radius: 50,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(30)),
                  Container(
                    child: Text(
                      "Hello ${user.displayName} you are signed up as ${user.email}",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(30)),
                  RaisedButton(
                    child: Text('Sign Out'),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: signOutUser,
                  ),
                ],
              ),
      ),
    );
  }
}
