import 'dart:async';
import 'package:chatz/authenticate/authenticate.dart';
import 'package:chatz/home/home.dart';
import 'package:chatz/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Timer(
        Duration(seconds: 3),() =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => user==null?Authenticate():Home()
            )
        )
    );
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )
          ),
          width: 170,
          height: 100,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
