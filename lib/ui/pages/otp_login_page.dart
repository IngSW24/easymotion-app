import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:otp_input_editor/otp_input_editor.dart';

class OTPLoginPage extends StatefulHookWidget {
  const OTPLoginPage({super.key, required this.email});

  final String email;

  @override
  State<OTPLoginPage> createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage> {
  String? _otpCode;
  bool _loginFailed = false;

  @override
  Widget build(BuildContext context) {
    final loginOtp = useLoginOtpFn(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Inserisci il codice a 6 cifre che abbiamo inviato a: ${widget.email}",
              ),
            ),
            if (_loginFailed)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Center(
                  child: Text(
                    "Codice OTP non valido",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OtpInputEditor(
                otpLength: 6,
                onOtpChanged: (value) => setState(() {
                  _otpCode = value;
                }),
                obscureText: false,
                boxDecoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 32, bottom: 16),
              child: FilledButton.icon(
                icon: Icon(Icons.login),
                onPressed: () async {
                  if (_otpCode == null) return;

                  bool status = await loginOtp(
                      OtpLoginDto(email: widget.email, otp: _otpCode!));
                  if (!status) {
                    setState(() {
                      _loginFailed = true;
                    });
                  } else if (context.mounted) {
                    context.go("/explore");
                  } else {
                    debugPrint("Error: unmounted context");
                  }
                },
                label: Text("Login"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
