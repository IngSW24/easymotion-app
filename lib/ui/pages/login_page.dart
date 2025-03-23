import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "", _password = "";

  void onSave() {
    print("$_username,,$_password");
    context.go("/explore");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(label: Text("Username/e-mail")),
                  onChanged: (String value) {
                    setState(() {
                      _username = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Text("Password"),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child:
                      ElevatedButton(onPressed: onSave, child: Text("Login")))
            ],
          ),
        ));
  }
}
