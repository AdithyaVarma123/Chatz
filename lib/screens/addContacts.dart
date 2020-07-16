import 'dart:async';

import 'package:chatz/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatz/models/user.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class addContacts extends StatefulWidget {
  @override
  _addContactsState createState() => _addContactsState();
}

// ignore: camel_case_types
class _addContactsState extends State<addContacts> {

  String contact;
  String error='';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contacts'),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: <Widget>[
              Text(
                'Enter Contact name:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'name',
                ),
                validator: (val)=>val.isEmpty?'enter a name':null,
                onChanged: (val){
                  setState(() {
                    contact = val;
                  });
                },
              ),

              SizedBox(height: 20),
              RaisedButton(
                color: Colors.blue[100],
                child: Text('Send request'),
                onPressed: ()async{
                  dynamic result = await DatabaseService(uid:user.uid,name:user.name,email:user.email).searchContact(contact);
                  if(result=='no user found'){
                    setState(() {
                      error = 'User not found';
                      Timer(Duration(seconds: 2), () {
                        setState(() {
                          error='';
                        });
                      });
                    });}
                  else
                    setState(() {
                      error = 'Request sent to $contact';
                      Timer(Duration(seconds: 2), () {
                        setState(() {
                          error='';
                        });
                      });
                    });
                },
              ),
              SizedBox(height: 20),
              Text(
                  error,
                  style:TextStyle(color: Colors.red,fontSize: 20)
              )
            ],
          ),
        ),
      ),
    );
  }
}


