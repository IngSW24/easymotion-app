import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

import '../../../data/hooks/use_categories.dart';
import '../../../data/hooks/use_courses.dart';
import '../../../data/hooks/use_subscriptions.dart';

class RefreshButton extends HookWidget {
  const RefreshButton({super.key, required this.icon});

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    return IconButton(
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
        icon: icon);
  }
}
