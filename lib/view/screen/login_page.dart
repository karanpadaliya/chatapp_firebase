import 'package:chatapp_firebase/util/auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          // color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Future<Map<String, dynamic>> res =
                      AuthHelper.authHelper.signInWithAnonymosuly();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("User Sign In Sucessfully"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  //   Push user to home Page
                  Navigator.pushNamed(context, "home_page");
                },
                child: Text("Anonymosly Login"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: validateAndSignUp,
                    child: Text("Sign up"),
                  ),
                  ElevatedButton(
                    onPressed: validateAndSignIn,
                    child: Text("Sign in"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> res =
                      await AuthHelper.authHelper.signInWithGoogle();

                  if (res["user"] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("User Sign In Successfully..."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    // push a user to home_page
                    Navigator.of(context)
                        .pushReplacementNamed('home_page', arguments: res["user"]);
                  } else if (res["error"] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res["error"]),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("User Sign In failed..."),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.g_mobiledata),
                    Text("Login With Google"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign up form
  validateAndSignUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("SignUp"),
        content: Form(
          key: signUpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter email first" : null;
                },
                onSaved: (val) {
                  email = val;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Email",
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter password first" : null;
                },
                onSaved: (val) {
                  password = val;
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Password",
                  labelText: "Password",
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (signUpFormKey.currentState!.validate()) {
                signUpFormKey.currentState!.save();

                // ToDo: signup calling here
                Map<String, dynamic> res = await AuthHelper.authHelper
                    .signUp(email: email!, password: password!);
                if (res["user"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("User Sign Up Successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (res["error"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res["error"]),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User Sign Up failed..."),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
              emailController.clear();
              passwordController.clear();

              email = null;
              password = null;

              Navigator.pop(context);
            },
            child: Text("Sign Up"),
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              backgroundColor: WidgetStatePropertyAll(CupertinoColors.link),
            ),
          ),
        ],
      ),
    );
  }

  validateAndSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sign In"),
        content: Form(
          key: signInFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter email first" : null;
                },
                onSaved: (val) {
                  email = val;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter email",
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter password first" : null;
                },
                onSaved: (val) {
                  password = val;
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter password",
                  labelText: "Password",
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          OutlinedButton(
            child: Text("Sign In"),
            onPressed: () async {
              if (signInFormKey.currentState!.validate()) {
                signInFormKey.currentState!.save();

                Map<String, dynamic> res = await AuthHelper.authHelper
                    .signIn(email: email!, password: password!);

                Navigator.pop(context);

                if (res["user"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("User Sign In Successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  // push a user to home_page
                  Navigator.of(context)
                      .pushNamed('home_page', arguments: res["user"]);
                } else if (res["error"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res["error"]),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("User Sign In failed..."),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                emailController.clear();
                passwordController.clear();

                email = null;
                password = null;
              }
            },
          ),
        ],
      ),
    );
  }
}
