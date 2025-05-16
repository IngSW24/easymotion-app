import 'package:easymotion_app/data/hooks/use_categories.dart';
import 'package:easymotion_app/data/hooks/use_courses.dart';
import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

class ErrorAlert extends HookWidget {
  const ErrorAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline, color: Colors.red, size: 60),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Si è verificato un errore', textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () {
              queryClient.invalidateQueries([
                courseQueryKey,
              ]);
              queryClient.invalidateQueries([
                subscriptionsQueryKey,
              ]);
              queryClient.invalidateQueries([
                coursesSubscribedQueryKey,
              ]);
              queryClient.invalidateQueries([categoriesQueryKey]);
            },
            child: Text('Riprova'),
          ),
        ),
      ],
    );
  }
}
