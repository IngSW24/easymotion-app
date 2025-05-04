import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SubscribeButton extends HookWidget {
  const SubscribeButton({super.key, required this.courseID});

  final String courseID;

  bool containsCourse(SubscriptionDto sub, String courseID) {
    return sub.course.id == courseID;
  }

  @override
  Widget build(BuildContext context) {
    final subscriptions = useUserSubscriptions(context);
    final create = useCreateSubscription(context);
    final delete = useDeleteSubscription(context);

    if (subscriptions.isLoading) {
      return LoadingIndicator();
    }

    final subList = subscriptions.data?.data;
    if (subscriptions.isError || subList == null) {
      return ErrorAlert();
    }

    if (subList.any((sub) => containsCourse(sub, courseID))) {
      return FilledButton.icon(
          icon: Icon(Icons.close),
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).colorScheme.error)),
          onPressed: () async {
            await delete(SubscriptionDeleteDto(courseId: courseID));
            if (context.mounted) context.go("/my_courses");
          },
          label: Text("Unsubscribe"));
    }

    return FilledButton.icon(
        icon: Icon(Icons.check),
        onPressed: () async {
          await create(SubscriptionCreateDto(courseId: courseID));
          if (context.mounted) context.go("/my_courses");
        },
        label: Text("Subscribe"));
  }
}
