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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileInfo("Nome completo",
                "${user.firstName} ${user.middleName != null ? "${user.middleName} " : ""}${user.lastName}",
                icon: Icons.person),
            if (user.birthDate != null)
              _buildProfileInfo("Data di nascita", user.birthDate ?? ""),
            _buildProfileInfo("Email", user.email, icon: Icons.email),
            if (user.phoneNumber != null)
              _buildProfileInfo("Telefono", user.phoneNumber ?? "",
                  icon: Icons.phone),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: logout, // Chiama la funzione di logout
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(icon, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
