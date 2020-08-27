import 'package:chatz/home/contactlist.dart';
import 'package:chatz/models/contacts.dart';
import 'package:chatz/models/user.dart';
import 'package:chatz/services/auth.dart';
import 'package:chatz/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {

  bool haveContacts=false;


  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamProvider<List<Contacts>>.value(
      value:DatabaseService(uid:user.uid,name: user.name,email: user.email).contacts,
      child:Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Chatz',style: TextStyle(fontSize: 30),),
            backgroundColor: Colors.black45,
          ),
        body:contactlist(),
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushNamed('addContacts');
          },
        ),
        drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                user.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),ListTile(
              leading:Icon(Icons.contacts),
              title: Text('Requests'),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, 'requestPage');
              },
            ),
            ListTile(
              leading:Icon(Icons.person),
              title: Text('Logout'),
              onTap: ()async{
                Navigator.pop(context);
                await _auth.signOut();
              },
            ),

          ],
        ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          color: Colors.black87,
          shape: CircularNotchedRectangle(),
          child:new Opacity(opacity: 0.0, child: new Padding(
            padding: const EdgeInsets.all(10),
            child: new Icon(Icons.person, color: CupertinoColors.activeBlue),
          ))
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }
}
