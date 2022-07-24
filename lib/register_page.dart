import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/firebase_storage.dart';

import 'firebase_events.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String date = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();

  @override
  void initState() {
    date = DateTime.now().toString().substring(0, 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(padding: const EdgeInsets.symmetric(vertical: 40), children: [
              const SizedBox(height: 20),
              TextField(
                  enableInteractiveSelection: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _nameController,
                  onSubmitted: (text) {},
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                      hintText: 'Name')),
              const SizedBox(height: 20),
              TextField(
                  enableInteractiveSelection: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _emailController,
                  onSubmitted: (text) {},
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                      hintText: 'Email')),
              const SizedBox(height: 20),
              TextField(
                  enableInteractiveSelection: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _passwordController,
                  onSubmitted: (text) {},
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                      hintText: 'Password')),
              const SizedBox(height: 20),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  height: 65,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                  child: Text(date, style: const TextStyle(fontSize: 22, color: Colors.white))),
              const SizedBox(height: 20),
              TextField(
                  enableInteractiveSelection: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _hobbiesController,
                  onSubmitted: (text) {},
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                      hintText: 'Hobbies')),
              const SizedBox(height: 80),
              InkWell(
                child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                    child: const Text('Register', style: TextStyle(fontSize: 22, color: Colors.white))),
                onTap: () async {
                  final user = await FirebaseEvents.registerUsingEmailPasswordEvent(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: _nameController.text);
                  if (user == null) {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        backgroundColor: Colors.blue,
                        context: context,
                        builder: (context) {
                          return Container(
                              child: const Text('Enter details are incorrect',
                                  style: TextStyle(fontSize: 22, color: Colors.white)),
                              height: 100,
                              alignment: Alignment.center);
                        });
                  } else {
                    //  FirebaseEvents().getPreviousSearchPostCodes(_nameController.text, date, _hobbiesController.text);
                    List<String> saveData = [];
                    saveData.add(_nameController.text);
                    saveData.add(date);
                    saveData.add(_hobbiesController.text);
                    FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}')
                        .uploadAndUpdatePersonsList(saveData);
                    var data = await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}')
                        .getUsersList("User");
                    if (data != null) {
                      List<dynamic> userList = data['UsersList'];
                      userList.add('${_nameController.text}-${FirebaseAuth.instance.currentUser?.uid}');
                      FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}')
                          .uploadAndUpdateUsers(userList);
                    } else {
                      List<dynamic> userList = [];
                      userList.add('${_nameController.text}-${FirebaseAuth.instance.currentUser?.uid}');
                      FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}')
                          .uploadAndUpdateUsers(userList);
                    }
                    Navigator.pushNamed(context, '/home');
                  }
                },
              ),
              const SizedBox(height: 30),
              Center(
                  child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Have account? Login',
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ))),
            ])));
  }
}
