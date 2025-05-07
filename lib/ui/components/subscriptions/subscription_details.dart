import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SubscriptionDetails extends HookWidget {
  const SubscriptionDetails({super.key, required this.courseID});

  final String courseID;

  @override
  Widget build(BuildContext context) {
    final subscriptions = useUserSubscriptions(context);
    final create = useCreateSubscription(context);

    if (subscriptions.isLoading) {
      return LoadingIndicator();
    }

    final subList = subscriptions.data?.data;
    if (subscriptions.isError || subList == null) {
      debugPrint(subscriptions.data?.toString());
      return ErrorAlert();
    }

    SubscriptionDtoWithCourse? subscriptionDetails = null;
    try {
      subscriptionDetails = subList.firstWhere((e) {
        return e.courseId == courseID;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    if (subscriptionDetails != null) {
      return Column(
        children: [
          _buildSubscriptionInfo(
              "Creato il", subscriptionDetails.createdAt.toLocal().toString())
        ],
      );
    }

    return FilledButton.icon(
        icon: Icon(Icons.check),
        onPressed: () async {
          await create(SubscriptionRequestDto(
              courseId: courseID, subscriptionRequestMessage: 'MESSAGE'));
          if (context.mounted) context.go("/my_courses");
        },
        label: Text("Subscribe"));
  }

  Widget _buildSubscriptionInfo(String label, String value, {IconData? icon}) {
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
