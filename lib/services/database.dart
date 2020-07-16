import 'package:chatz/models/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';



class DatabaseService {

  final String uid;
  final String name;
  final String email;
  DatabaseService({this.uid,this.name,this.email});







  // collection reference
  final CollectionReference collection =  Firestore.instance.collection('users');

  Future updateUserData(String email,String name,String profilePhoto,String uid)async{
    return await collection.document(uid).setData({
      'email':email,
      'name':name,
      'profilePhoto':profilePhoto,
      'uid':uid
    },merge: true);
  }

  //Search Contact
  Future searchContact(String contact)async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection('users').where('name', isEqualTo: contact).getDocuments();
    var documents = querySnapshot.documents;


    if(documents.isEmpty)
    return 'no user found';
    else
      {
       return await Firestore.instance.collection('Requests').document().setData({
          'email':this.email,
          'senderName':this.name,
          'uid':this.uid,
          'RecieverName':documents.first.data['name']
        });
      }

  }


  //stream of requests
  Stream<List<Contacts>> get requests{
    return Firestore.instance.collection('Requests').where('RecieverName',isEqualTo: this.name).snapshots()
        .map(_requestListFromSnapshot);
  }


  //list of Contacts of requests
  List<Contacts> _requestListFromSnapshot(QuerySnapshot snapshot)
  {
     return snapshot.documents.map((doc){
       return Contacts(
           name:doc.data['senderName'] ?? '',
           email: doc.data['email'] ?? '',
           uid: doc.data['uid'] ?? '',
           profilePhoto: null
       );
     }).toList();
  }



  //stream of contacts
  Stream<List<Contacts>> get contacts {
    return Firestore.instance.collection('users').document(uid).collection('contacts').snapshots()
  .map(_contactListFromSnapshot);
  }


  //list of Contacts for user
  List<Contacts> _contactListFromSnapshot(QuerySnapshot snapshot)
  {

    return snapshot.documents.map((doc) {
return Contacts(
  name:doc.data['name'] ?? '',
  email: doc.data['email'] ?? '',
  uid: doc.documentID ?? '',
  profilePhoto: doc.data['profilePhoto'] ?? '',
);
    }).toList();
  }

//delete request
Future deleteRequest(String senderName)async{
    QuerySnapshot documents =  await Firestore.instance.collection('Requests').where('senderName',isEqualTo:senderName ).where('RecieverName',isEqualTo: this.name).getDocuments();
    String docId = documents.documents.first.documentID;
    Firestore.instance.collection("Requests").document(docId).delete();
}

//add contact
Future addContact(String email,String name,String uid,String senderName)async{

    String docId = randomAlphaNumeric(20);

    await this.deleteRequest(senderName);


  await Firestore.instance.collection('chats').document(docId).setData({
    'contact1':this.uid,
    'contact2':uid

  });
  await Firestore.instance.collection('users').document(this.uid).collection('contacts').document().setData({
    'email':email,
    'name':name,
    'profilePhoto':null,
    'uid':uid,
    'chatDocumentId':docId

  });
  await Firestore.instance.collection('users').document(uid).collection('contacts').document().setData({
    'email':this.email,
    'name':this.name,
    'profilePhoto':null,
    'uid':this.uid,
    'chatDocumentId':docId
  });
}


}