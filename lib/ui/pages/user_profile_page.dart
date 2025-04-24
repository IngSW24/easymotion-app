import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'loading_page.dart';

class UserProfilePage extends HookWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = useUserInfo(context).call();
    final userIsLoading = useIsLoading(context).call();
    final logout = useLogoutFn(context);

    if (user == null) {
      if (!userIsLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
      }
      return LoadingPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.firstName + user.lastName),
      ),
      body: Column(
        children: [
          Text("Nome: ${user.firstName}"),
          if (user.middleName != null) Text("Secondo nome: ${user.middleName}"),
          Text("Cognome: ${user.lastName}"),
          Text("Data di nascita: ${user.birthDate}"),
          Text("Email: ${user.email}"),
          Text("Telefono: ${user.phoneNumber}"),
          TextButton(
              onPressed: logout,
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
    );
  }
}
