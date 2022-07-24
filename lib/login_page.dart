import 'package:flutter/material.dart';

import 'firebase_events.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(height: 50),
              TextField(
                  enableInteractiveSelection: true,
                  textCapitalization: TextCapitalization.characters,
                  controller: _emailController,
                  onChanged: (text) {},
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
                  obscureText: true,
                  controller: _passwordController,
                  onSubmitted: (text) {},
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                      hintText: 'password')),
              const SizedBox(height: 80),
              InkWell(
                child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    )),
                onTap: () async {
                  final user = await FirebaseEvents.signInUsingEmailPasswordEvent(
                      email: _emailController.text, password: _passwordController.text);
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
                    Navigator.pushNamed(context, '/home');
                  }
                },
              ),
              const SizedBox(height: 30),
              InkWell(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'Don\'t have account? Create Account',
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ])));
  }
}
