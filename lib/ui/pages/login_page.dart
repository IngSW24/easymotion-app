import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulHookWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "user@easymotion.it", _password = "ingsw24easymotion!";

  @override
  Widget build(BuildContext context) {
    final login = useLoginFn(context);

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
                  obscureText: true,
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
                  child: ElevatedButton(
                      onPressed: () async {
                        bool status = await login(
                            SignInDto(email: _username, password: _password));
                        if (status && context.mounted) context.go("/explore");
                      },
                      child: Text("Login"))),
            ],
          ),
        ));
  }
}
