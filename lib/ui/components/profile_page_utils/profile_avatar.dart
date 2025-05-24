import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Icon(Icons.person, size: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }
}