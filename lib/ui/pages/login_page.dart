import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/common/constants.dart';

class LoginPage extends StatefulHookWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "", _password = "";
  bool loginFailed = false;

  Future<void> onRegisterClick() async {
    final Uri uri = Uri.parse(registerUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossibile aprire l\'URL: $uri')),
      );
    } else {
      debugPrint("Impossibile aprire l\'URL: $uri");
    }
  }

  @override
  Widget build(BuildContext context) {
    final login = useLoginFn(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          children: [
            if (loginFailed)
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Username o password non valide",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
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
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
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
                      if (!status) {
                        setState(() {
                          loginFailed = true;
                        });
                      } else if (context.mounted) {
                        context.go("/explore");
                      }
                    },
                    child: Text("Login"))),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextButton(
                  onPressed: onRegisterClick,
                  child: Text("Registati a Easymotion")),
            )
          ],
        ));
  }
}
