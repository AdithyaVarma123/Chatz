

import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'GalleryPage.dart';


class ScreenArguments {
  final String chatid;
  final String name;
  SharedPreferences prefs;

  ScreenArguments(this.chatid, this.name,this.prefs);
}

// ignore: camel_case_types
class chatPage extends StatefulWidget {


  @override
  _chatPageState createState() => _chatPageState();
}

// ignore: camel_case_types
class _chatPageState extends State<chatPage> {


  final db = Firestore.instance;
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;




  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot){
    return <Widget>[
      Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            documentSnapshot.data['image_url'] != ''?
             InkWell(
               onLongPress: (){
                 showDialog(context: context,builder: (BuildContext context){
                   return AlertDialog(
                     title: Text('delete photo?'),
                     actions: <Widget>[
                       FlatButton(
                         child: Text('no'),
                         onPressed: () => Navigator.pop(context),
                       ),
                       FlatButton(
                         child: Text('yes'),
                         onPressed: ()async{
                           QuerySnapshot documents =  await chatReference.where('time',isEqualTo: documentSnapshot.data['time']).getDocuments();
                           String docId = documents.documents.first.documentID;
                           chatReference.document(docId).delete();
                           Navigator.pop(context);
                         },
                       )
                     ],
                   );
                 });
               },
               onTap: (){
                 Navigator.of(context).push(
                     MaterialPageRoute(
                       builder: (context) => GalleryPage(
                         imagePath: documentSnapshot.data['image_url'],
                       )
                     )
                 );
               },child:new Container(
                 child: Image.network(documentSnapshot.data['image_url'],fit: BoxFit.fitWidth),
                 height: 200,
                 width: 200,
                 color: Color.fromRGBO(0, 0, 0, 0.2),
                 padding: EdgeInsets.all(5),
               )

             )
            :InkWell(
              onLongPress: (){

                showDialog(context: context,builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('delete message?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('no'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text('yes'),
                        onPressed: ()async{
                          QuerySnapshot documents =  await chatReference.where('time',isEqualTo: documentSnapshot.data['time']).getDocuments();
                          String docId = documents.documents.first.documentID;
                          chatReference.document(docId).delete();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });

              },
              child: Bubble(
                margin: BubbleEdges.all(2),
                nip:BubbleNip.rightTop,color: Colors.green[100],
                elevation: 5,
                child: Text(documentSnapshot.data['text']),
              ),
            )
          ],
        ),
      )
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            documentSnapshot.data['image_url'] != ''?
            InkWell(
             onTap: (){
               Navigator.of(context).push(
               MaterialPageRoute(
                builder: (context) => GalleryPage(
                  imagePath: documentSnapshot.data['image_url'],)
                                )
                            );
             },
    child:new Container(
    child: Image.network(documentSnapshot.data['image_url'],fit: BoxFit.fitWidth),
    height: 150,
    width: 150,
    color: Color.fromRGBO(0, 0, 0, 0.2),
    padding: EdgeInsets.all(5),
    )
    )
    :Bubble(
    margin: BubbleEdges.all(2),
              nip:BubbleNip.leftTop,
              elevation: 8,
              child: Text(documentSnapshot.data['text']),
            )
          ],
        ),
      )
  ];
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot){
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return snapshot.data.documents
        .map<Widget>((doc) => Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: new Row(
        children: doc.data['sender_id']!=args.prefs.getString('uid')
            ?generateReceiverLayout(doc)
            :generateSenderLayout(doc),
      ),
    )).toList();
  }


  @override
  Widget build(BuildContext context) {


    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    chatReference = db.collection('chats').document(args.chatid).collection('messages');
    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          image:DecorationImage(image:AssetImage('assets/bk.jpeg'),fit: BoxFit.cover)
        ),
        child: new Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: chatReference.orderBy('time',descending: true).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Text("No Chat");
                return Expanded(
                  child: new ListView(
                    reverse: true,
                    children: generateMessages(snapshot),
                  ),
                );
              },
            ),
            new Divider(height: 10.0),
            Bubble(
              radius: Radius.circular(50),
              child: new Container(
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(color: Theme.of(context).canvasColor),
                child: _buildTextComposer(),
              ),
            ),
            new Builder(builder: (BuildContext context) {
              return new Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ),
    );
  }

  IconButton getDefaultSendButton(){
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isWriting
      ?() => _sendText(_textController.text)
  :null,
  );
}

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isWriting
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      PickedFile image = await ImagePicker().getImage(
                          source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      StorageReference storageReference = FirebaseStorage
                          .instance
                          .ref()
                          .child('chats/img_' + timestamp.toString() + '.jpg');
                      File imageFile = new File(image.path);
                      StorageUploadTask uploadTask =
                      storageReference.putFile(imageFile);
                      await uploadTask.onComplete;
                      String fileUrl = await storageReference.getDownloadURL();
                      _sendImage(messageText: null, imageUrl: fileUrl);
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWriting = messageText.length > 0;
                    });
                  },
                  onSubmitted: _sendText,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }





  Future<Null> _sendText(String text) async {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    _textController.clear();

    chatReference.add({
      'text': text,
      'sender_id': args.prefs.getString('uid'),
      'sender_name': args.prefs.getString('name'),
      'profile_photo': null,
      'image_url': '',
      'time': FieldValue.serverTimestamp(),
    }).then((documentReference) {
      setState(() {
        _isWriting = false;
      });

    }).catchError((e) {
    });
  }

  void _sendImage({String messageText, String imageUrl}) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    chatReference.add({
      'text': messageText,
      'sender_id': args.prefs.getString('uid'),
      'sender_name': args.prefs.getString('name'),
      'profile_photo': args.prefs.getString('profile_photo'),
      'image_url': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });
  }
}



