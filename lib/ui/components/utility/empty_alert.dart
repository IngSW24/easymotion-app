import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmptyAlert extends HookWidget {
  const EmptyAlert({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.not_interested, color: Colors.grey, size: 60),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
              'Nessun elemento corrisponde ai criteri di ricerca, prova a togliere qualche filtro',
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
