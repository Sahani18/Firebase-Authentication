import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  UserCredential user;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _name, _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  navigateToSignInScreen() {
    Navigator.pushReplacementNamed(context, "/SignIn");
  }

  signUp() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        // after creation of new user update the name parameter in firebase
        if (user != null) {
          _auth.currentUser.updateProfile(displayName: _name);
         // _auth.currentUser?.reload();
         Navigator.pushReplacementNamed(context, "/SignIn");
        }
      } catch (e) {
        showError(e.message);
      }
    }
  }

  showError(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              RaisedButton(
                child: Text('OK'),
                  textColor: Colors.green,
                  onPressed: () {
                Navigator.of(context).pop();
              })
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 45, bottom: 50),
                child: Text(
                  'Create an Account ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'Name',
                  ),
                  onSaved: (value) => _name = value,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'Email',
                  ),
                  onSaved: (value) => _email = value,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 20, bottom: 40, left: 20, right: 20),
                child: TextFormField(

                  controller: password,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Password',
                  ),
                  onSaved: (value) => _password = value,
                ),
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: signUp,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
