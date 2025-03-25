import 'package:easymotion_app/api-client-generated/schema.models.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../data/hooks/use_auth.dart';

class LoginPage extends StatefulHookWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "", _password = "";

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
                        await login.mutate(
                            SignInDto(email: _username, password: _password));
                        print(login
                            .data?.accessToken); // TODO: ritardo di 1 chiamata
                      },
                      child: Text("Login")))
            ],
          ),
        ));
  }
}
