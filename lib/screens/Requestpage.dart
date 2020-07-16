import 'package:chatz/models/user.dart';
import 'package:chatz/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class requestPage extends StatefulWidget {
  @override
  _requestPageState createState() => _requestPageState();
}

class _requestPageState extends State<requestPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body:StreamBuilder(
        stream:DatabaseService(uid:user.uid,name:user.name,email:user.email).requests,
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if(snapshot.hasError)
            return Scaffold(
              appBar: AppBar(title:Text('has error')),
            );
          else if(snapshot.connectionState==ConnectionState.active && snapshot.data.length==0)
            return Center(
                child: Text(
                    'no requests',
                style: TextStyle(fontSize: 30,color: Colors.grey),
                ));
          else if(snapshot.hasData)
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data.length??0,
            itemBuilder: (BuildContext context, int index){
              return Container(
                height: 50,
                color: Colors.amber,
                child: Row(
                  children: <Widget>[
                    Expanded(child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                            snapshot.data[index].name,
                          style: TextStyle(fontSize: 15),
                        ))),
                    Padding(padding:EdgeInsets.all(2),child:RaisedButton.icon(onPressed: ()async{
                      DatabaseService(uid:user.uid,name:user.name,email:user.email).addContact(snapshot.data[index].email,snapshot.data[index].name,snapshot.data[index].uid,snapshot.data[index].name);
                    },
                        icon: Icon(Icons.add),
                        label: Text('accept'))),
                    Padding(padding:EdgeInsets.all(2),
                        child:RaisedButton.icon(
                        onPressed: ()async{
                        DatabaseService(uid:user.uid,name:user.name,email:user.email).deleteRequest(snapshot.data[index].name);
                        },
                        icon: Icon(Icons.block),
                        label: Text('decline'))),
                  ],
                ));
            },
          );
          else
            {return null;}
        },
      )
    );
  }
}
