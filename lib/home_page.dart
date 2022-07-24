import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late bool isShow = false;
  int indexValue = 0;
  List<dynamic> userList = [];
  List<dynamic> requests = [];

  Future getUserList() async {
    var data = await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').getUsersList('User');
    if (data != null) {
      setState(() {
        for (var element in data['UsersList']) {
          if (element.toString().split('-').first == FirebaseAuth.instance.currentUser?.displayName) {
          } else {
            userList.add(element);
            requests.add('Add Friend');
          }
        }
      });
      var requestData =
          await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').getRequestData("Request");
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (requestData != null) {
        for (var request in requestData['UserRequests']) {
          final data = request.toString().split('-');
          if (currentUserId == data[0] || currentUserId == data[2]) {
            userList.forEach((element) {
              if (element.toString().split('-').last == data[0]) {
                requests[userList.indexOf(element)] = data[1];
              }
              if (element.toString().split('-').last == data[2]) {
                requests[userList.indexOf(element)] = data[1];
              }
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    getUserList();
    sideAnimation(const Offset(0.0, 0.0), const Offset(0.0, 0.0), 300);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  sideAnimation(Offset begin, Offset end, int time) {
    _controller = AnimationController(
      duration: Duration(milliseconds: time),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(centerTitle: true, title: const Text('Users'), automaticallyImplyLeading: false, actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                  child: const CircleAvatar(
                      child: Icon(Icons.account_circle, size: 30), backgroundColor: Colors.white),
                  onTap: () async {
                    final data =
                        await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').getPersonsList();
                    print(data);

                    if (data != null) {
                      Navigator.pushNamed(context, '/profile', arguments: data['UserInfo']);
                    }
                  }))
        ]),
        body: GestureDetector(
          child: Column(children: [
            const SizedBox(height: 5),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 50,left: 4,right: 4),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                            color: const Color(0xFF9E824F),
                            child: Container(
                                height: 58,
                                padding: const EdgeInsets.only(left: 10, right: 3),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(userList[index].toString().split('-').first.toUpperCase(),
                                      style: const TextStyle(
                                          letterSpacing: .5,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Colors.white)),
                                  if (isShow == true && indexValue == index && requests[index] != 'Success')
                                    SlideTransition(
                                        position: _animation,
                                        child: GestureDetector(
                                            child: Container(
                                                width: 145,
                                                alignment: Alignment.center,
                                                height: 40,
                                                child: Text(requests[index],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black)),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10))),
                                            onTap: () async {
                                              if (requests[index] == "Add Friend") {
                                                uploadRequestData("Sent Request", index);
                                              } else if (requests[index] == "Confirm Request") {
                                                uploadRequestData("Success", index);
                                              }
                                            }))
                                ])),
                            margin: const EdgeInsets.only(bottom: 5)),
                        onTap: () => setState(() {
                          isShow = true;
                          indexValue = index;
                          if (requests[index] == "Success") {
                            Navigator.pushNamed(context, '/chat',
                                arguments: userList[index].toString().split('-').last);
                          } else {
                            sideAnimation(const Offset(1.0, 0.0), const Offset(0.0, 0.0), 800);
                          }
                        }),
                      );
                    }))
          ]),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ));
  }

  uploadRequestData(String request, int index) async {
    var data = await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').getRequestData("Request");
    if (data != null) {
      List<dynamic> userRequests = [];
      userRequests.addAll(data['UserRequests']);
      userRequests.add(
          '${FirebaseAuth.instance.currentUser?.uid}-$request-${userList[index].toString().split('-').last}');
      FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').uploadAndUpdateUserRequests(userRequests);
    } else {
      List<dynamic> userRequests = [];
      userRequests.add(
          '${FirebaseAuth.instance.currentUser?.uid}-$request-${userList[index].toString().split('-').last}');
      FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').uploadAndUpdateUserRequests(userRequests);
    }
  }
}
