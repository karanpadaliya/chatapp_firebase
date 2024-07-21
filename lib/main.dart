import 'package:chatapp_firebase/firebase_options.dart';
import 'package:chatapp_firebase/view/screen/home_page.dart';
import 'package:chatapp_firebase/view/screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        initialRoute: "login_page",
        routes: {
          "login_page": (context) => LoginPage(),
          "home_page": (context) => HomePage(),
        },
        onUnknownRoute: (settings) {
          Center(child: Text("onUnknownRoute....."));
        },
      ),
    ),
  );
}
