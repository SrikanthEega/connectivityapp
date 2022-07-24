import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStorage {
  final String uid;

  FirebaseStorage(this.uid);

  final CollectionReference userInfo = FirebaseFirestore.instance.collection('UserInfo');
  final CollectionReference users = FirebaseFirestore.instance.collection('UsersList');
  final CollectionReference userRequests = FirebaseFirestore.instance.collection('UserRequests');
  final CollectionReference chat = FirebaseFirestore.instance.collection('Chat');

  Future uploadAndUpdatePersonsList(List<dynamic> info) async {
    return await userInfo.doc(uid).set({
      'UserInfo': info,
    });
  }

  Future uploadAndUpdateUsers(List<dynamic> usersList) async {
    return await users.doc('User').set({
      'UsersList': usersList,
    });
  }
  Future uploadAndUpdateUserRequests(List<dynamic> requests) async {
    return await userRequests.doc('Request').set({
      'UserRequests': requests,
    });
  }
  Future uploadAndUpdateChat(List<dynamic> chatHistory) async {
    return await chat.doc(uid).set({
      'ChatHistory': chatHistory,
    });
  }

  Future<dynamic> getPersonsList() async {
    var userInfo;
    await FirebaseFirestore.instance.collection("UserInfo").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (uid == result.id) {
          userInfo = result.data();
        }
      });
    });
    return userInfo;
  }
  Future<dynamic> getUsersList(String user) async {

    var usersList;
    await FirebaseFirestore.instance.collection("UsersList").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (user == result.id) {
          usersList = result.data();
        }
      });
    });
    return usersList;
  }
  Future<dynamic> getRequestData(String documentName) async {
    var requestData;
    await FirebaseFirestore.instance.collection("UserRequests").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (documentName == result.id) {
          requestData = result.data();
        }
      });
    });
    return requestData;
  }
  Future<dynamic> getChatData() async {
    print('Hello Narayana');
    var requestData;
    await FirebaseFirestore.instance.collection("Chat").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('Hello Narayana');
        if (uid == result.id) {
          requestData = result.data();
          print(requestData);
        }
      });
    });
    return requestData;
  }

  /*final DocumentReference document =   Firestore.instance.collection("userdetails").document(uid);

  await document.get().then<dynamic>(( DocumentSnapshot snapshot) {

    var  first =snapshot.data;
      print('hello');
      print(first);
    });*/

  deleteData(String collectionName, String documentId) async {
    try {
      await FirebaseFirestore.instance.collection(collectionName).doc(documentId).delete();
    } catch (e) {}
  }
}
