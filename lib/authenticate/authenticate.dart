import 'package:chatz/authenticate/Register.dart';
import 'package:chatz/authenticate/sign_in.dart';
import 'package:flutter/cupertino.dart';

class Authenticate extends StatefulWidget {
  @override
  _authenticateState createState() => _authenticateState();
}

class _authenticateState extends State<Authenticate> {

  bool showSignIn = false;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn==true?SignIn(toggleView:toggleView):Register(toggleView:toggleView);
    ;
  }
}
