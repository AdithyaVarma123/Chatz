import 'package:chatz/services/auth.dart';
import 'package:chatz/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email='',password='',error = '';

  @override
  Widget build(BuildContext context) {
    return loading==true?Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Register',
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
                'Sign-in',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children:<Widget>[
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
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      if(_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if(result == 'user already exists')
                            setState(() {
                              loading = false;
                              error = 'email already in use';
                            });


                        else if(result == null){
                          setState(() {
                            loading = false;
                            error = 'please supply a vaild email';
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
          )]
      ),
      );
  }
}
