import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var email = TextEditingController();
  var password = TextEditingController();
  UserCredential user;
  String _email, _password;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (builder) => HomePage()));
      }
    });
  }

  void signIn() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {

          Navigator.pushReplacementNamed(context, "/");
        }
      } catch (e) {
        showError(e.message);
      }
    }
  }

  navigateToSignUpScreen() {

    Navigator.pushReplacementNamed(context, "/SignUp");
  }

  showError(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK')),
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
        title: Text('Firebase'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: ListView(
            children: [
              Center(
                  child: CircleAvatar(
                child: Text('FireBase'),
                backgroundColor: Colors.lightGreen,
                radius: 50,
              )),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email Required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSaved: (value) => _email = value,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Password';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSaved: (value) => _password = value,
                        ),
                      ),
                      RaisedButton(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        //color: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        onPressed: signIn,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      FlatButton(
                        child: Text('Create an account ?'),
                        onPressed: navigateToSignUpScreen,
                        hoverColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
