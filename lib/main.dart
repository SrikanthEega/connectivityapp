import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/chat_page.dart';
import 'package:untitled1/home_page.dart';
import 'package:untitled1/login_page.dart';
import 'package:untitled1/profile_page.dart';
import 'package:untitled1/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLogin = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        isLogin = true;
      }
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: 'login',
        routes: {
          '/login': (context) => const LoginPage(title: 'Login'),
          '/register': (context) => const RegisterPage(title: 'Register'),
          '/home': (context) => const HomePage(),
        },
        onGenerateRoute: (route) {
          if (route.name == '/profile') {
            return MaterialPageRoute(builder: (context) {
              final userInfo = route.arguments as List<dynamic>;
              return ProfilePage(userInfo: userInfo);
            });
          }
          if (route.name == '/chat') {
            return MaterialPageRoute(builder: (context) {
              final messageTo = route.arguments as String;
             // final chatData = route.arguments as List<dynamic>;
              return ChatPage(messageTo: messageTo);
            });
          }
        },
        title: 'Srikanth App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: isLogin == false ? const LoginPage(title: 'Login') : const HomePage());
  }
}
