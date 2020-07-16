import 'package:chatz/models/user.dart';
import 'package:chatz/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService{

final FirebaseAuth _auth = FirebaseAuth.instance;

User _userFromFirebaseUser(FirebaseUser user){
  return user != null ? User(uid:user.uid,name:user.email.substring(0,user.email.indexOf('@')),email:user.email):null;
}

Stream<User> get user{
  return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
}


Future signInWithEmailAndPassword(String email,String password) async {
  try{
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return _userFromFirebaseUser(user);
  }catch(e)
  {
    print(e.toString());
    if(e.code == 'ERROR_WRONG_PASSWORD'){
      return 'wrong password';
    }
    return null;
  }
}


//register with email and password
  Future registerWithEmailAndPassword(String email,String password) async {
  try{
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    //create a new document for the user with uid
    await DatabaseService(uid:user.uid,name:user.email.substring(0,user.email.indexOf('@')),email:user.email).updateUserData(user.email, user.email.substring(0,user.email.indexOf('@')), null,user.uid);


    return _userFromFirebaseUser(user);
  }catch(e)
  {
    print(e.toString());
    if(e is PlatformException)
      if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE')
    {
      return  'user already exists';
    }

      else
        return null;
  }
  }


//sign out
Future signOut() async{
  try{
return await _auth.signOut();
  }catch(e){
    print(e.toString());
    return null;
  }
}


}