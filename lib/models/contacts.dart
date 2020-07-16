class Contacts{
  final String name;
  final String email;
  final String uid;
  final String profilePhoto;
  Contacts({this.name,this.email,this.uid,this.profilePhoto});
  void printData(){
    print(this.name);
  print(this.email);
  print(this.uid);
}
}