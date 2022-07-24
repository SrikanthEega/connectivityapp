import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/firebase_events.dart';

class ProfilePage extends StatefulWidget {
  final List<dynamic> userInfo;

  const ProfilePage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isNameEdit = false;
  late bool isEmailEdit = false;

  void getData() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  ListView(children: [
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(widget.userInfo[0].toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                if (isNameEdit == false)
                  GestureDetector(
                      child: const Icon(Icons.edit, color: Color(0xFF9E824F),),
                      onTap: () => setState(() {
                            isNameEdit = true;
                          }))
              ]),
              if (isEmailEdit == true) const SizedBox(height: 20),
              if (isNameEdit == true)
                TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                        hintText: 'Edit name')),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${FirebaseAuth.instance.currentUser?.email}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                if (isEmailEdit == false)
                  GestureDetector(
                      child: const Icon(Icons.edit,color: Color(0xFF9E824F)),
                      onTap: () => setState(() {
                            isEmailEdit = true;
                          }))
              ]),
              if (isEmailEdit == true) const SizedBox(height: 20),
              if (isEmailEdit == true)
                TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                        hintText: 'Edit email')),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    width: 300,
                    child: Text(widget.userInfo[2],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                if (isEmailEdit == false)
                  GestureDetector(
                      child: const Icon(Icons.edit, color: Color(0xFF9E824F)),
                      onTap: () => setState(() {
                            isEmailEdit = true;
                          }))
              ]),
              const SizedBox(height: 50),
              InkWell(
                  child: const Text('Logout',
                      style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
                  onTap: () {
                    FirebaseEvents().logOutEvent();
                    Navigator.pushNamed(context, '/login');
                  }),
              const SizedBox(height: 80),
              if (isEmailEdit == true || isNameEdit == true)
                InkWell(
                    child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        height: 52,
                        width: double.infinity,
                        decoration:
                            BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                        child: const Text('Save', style: TextStyle(fontSize: 22, color: Colors.white))),
                    onTap: () {
                      setState(() {
                        isEmailEdit = false;
                        isNameEdit = false;
                      });
                    }),

              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Account created',
                        style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
                    Text('Last Updated',
                        style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.userInfo[1],
                        style:
                            const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
                    Text(DateTime.now().toString().substring(0, 10),
                        style:
                            const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 20)
              ]),
            ]),
        appBar: AppBar(title: const Text('Profile')));
  }
}
