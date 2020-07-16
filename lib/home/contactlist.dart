import 'package:chatz/models/contacts.dart';
import 'package:chatz/models/user.dart';
import 'package:chatz/screens/chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class contactlist extends StatefulWidget {
  @override
  _contactlistState createState() => _contactlistState();
}

class _contactlistState extends State<contactlist> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final contacts = Provider.of<List<Contacts>>(context);
    return contacts==null?Center(child: CircularProgressIndicator()):ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(top:8.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              onTap: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('uid', user.uid);
                prefs.setString('name', user.name);
                prefs.setString('profile_photo', null);
                QuerySnapshot documents = await Firestore.instance.collection('users').document(user.uid).collection('contacts').where('name',isEqualTo:contacts[index].name ).getDocuments();
                String chatid = documents.documents.first.data['chatDocumentId'];
                Navigator.pushNamed(context, 'chatPage',arguments: ScreenArguments(chatid,contacts[index].name,prefs));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.red[500],
              ),
              title: Text(contacts[index].name),
              subtitle: Text(contacts[index].email),
            ),
          ),
        );
      },);
  }
}
