import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_api.dart';
import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
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
    final api = useApi(context);

    if (subscriptions.isLoading) {
      return Text("Loading...");
    }

    final subList = subscriptions.data?.data;
    if (subscriptions.isError || subList == null) {
      return Text("Error: ${subscriptions.error}");
    }

    if (subList.any((sub) => containsCourse(sub, courseID))) {
      return FilledButton(
          onPressed: () async {
            await api.schema.subscriptionsDelete(
                body: SubscriptionDeleteDto(courseId: courseID));
            if (context.mounted) context.go("/my_courses");
          },
          child: Text("Unsubscribe"));
    }

    return FilledButton(
        onPressed: () async {
          await api.schema.subscriptionsPost(
              body: SubscriptionCreateDto(courseId: courseID));
          if (context.mounted) context.go("/my_courses");
        },
        child: Text("Subscribe"));
  }
}
