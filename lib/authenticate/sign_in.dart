import 'package:chatz/services/auth.dart';
import 'file:///C:/Users/Adithya%20Varma/AndroidStudioProjects/login_screen/lib/screens/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email='',password='',error = '';
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading==true?Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'LOGIN',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lobster'
          ),
        ),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
            widget.toggleView();
            },
            icon:Icon(Icons.person),
            label: Text(
              'Register',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(50, 20, 50, 450),
          color: Colors.orange[200],
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'email',
                    ),
                    validator: (val)=>val.isEmpty?'enter an email':null,
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                      decoration: InputDecoration(
                        hintText: 'password',
                      ),
                      validator: (val)=>val.length<6?'enter a password 6+ chars long':null,
                    obscureText: true,
                      onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      }
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if(_formKey.currentState.validate()) {
                          dynamic result=await _auth.signInWithEmailAndPassword(email, password);
                          if(result == 'wrong password')
                            {
                              setState(() {
                                error = 'password incorrect';
                              });
                              loading = false;
                            }
                          else if(result == null){
                            setState(() {
                              error = 'could not sign in with the given credentials';
                              loading = false;
                            });
                          }
                        }
                      }
                  ),
                  SizedBox(height:12),
                  Text(
                      error,
                      style:TextStyle(color: Colors.red,fontSize: 15)
                  )
                ],
              )
          ),
        ),]
      ),
    );
  }
}
