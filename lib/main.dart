import 'package:chatz/models/user.dart';
import 'package:chatz/screens/Requestpage.dart';
import 'package:chatz/screens/addContacts.dart';
import 'package:chatz/screens/chatPage.dart';
import 'package:chatz/screens/logo.dart';
import 'package:chatz/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes: {
          'logo':(context)=>Logo(),
          'addContacts':(context)=>addContacts(),
          'requestPage':(context)=>requestPage(),
          'chatPage':(context)=>chatPage(),
        },
      ),
    );
  }
}