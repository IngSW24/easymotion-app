import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/common/login_response.dart';
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
  bool _loginFailed = false, _obscurePassword = true;
  late final TextEditingController _usernameController, _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> onRegisterClick() async {
    final Uri uri = Uri.parse(registerUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Impossibile aprire il link. Assicurati di aver installato Google Chrome, o un altro browser')),
      );
    } else {
      debugPrint("Impossibile aprire l'URL: $uri");
    }
  }

  @override
  Widget build(BuildContext context) {
    final login = useLoginFn(context);

    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text('Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                  "Bentornato! \nInserisci le tue credenziali per accedere al tuo account Easymotion",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16)),
            ),
            if (_loginFailed)
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Username o password non valide",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    label: Text("Username/e-mail"),
                    border: OutlineInputBorder()),
                onChanged: (String value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off))),
                onChanged: (String value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: FilledButton.icon(
                    icon: Icon(Icons.login),
                    onPressed: () async {
                      LoginResponse status = await login(
                          SignInDto(email: _username, password: _password));
                      if (status == LoginResponse.error) {
                        setState(() {
                          _loginFailed = true;
                        });
                      } else if (context.mounted) {
                        if (status == LoginResponse.success) {
                          context.go("/explore");
                        } else if (status == LoginResponse.needOtp) {
                          context.go("/login/otp/$_username");
                        } else {
                          debugPrint("Error: unknown login response");
                        }
                      } else {
                        debugPrint("Error: unmounted context");
                      }
                    },
                    label: Text(
                      "Login",
                    ))),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextButton(
                  style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.secondary)),
                  onPressed: onRegisterClick,
                  child: Text("Registati a Easymotion")),
            )
          ],
        )));
  }
}
