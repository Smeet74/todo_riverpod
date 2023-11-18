import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rapidd_assignment/view/bottom_screen.dart';

import '../Auth/authentication.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      User? user = await Authentication.signInWithEmailPassword(
                          _email, _password);
                      if (user == null) {
                        // User does not exist, create a new user
                        user = await Authentication.createUserWithEmailPassword(
                            _email, _password);
                      }
                      if (user != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BottomScreen(user: user!)));
                      }
                    } catch (e) {
                      // Handle the error here
                    }
                  }
                },
                child: Text('Sign In'),
              ),
              // SizedBox(height: 25),
              // ElevatedButton(
              //   onPressed: () async {
              //     try {
              //       User? user = await Authentication.signInWithGoogle();
              //       if (user != null) {
              //         Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => BottomScreen(user: user)));
              //       }
              //     } catch (e) {
              //       // Handle the error here
              //     }
              //   },
              //   child: Text('Sign In with Google'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
