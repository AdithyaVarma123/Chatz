import 'dart:async';

import 'package:chatz/authenticate/authenticate.dart';
import 'package:chatz/home/home.dart';
import 'package:chatz/models/user.dart';
import 'package:chatz/screens/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'authenticate/Register.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);


    //either home or authenticate
    return Logo();
  }
}
