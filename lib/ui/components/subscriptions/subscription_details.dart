import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SubscriptionDetails extends HookWidget {
  SubscriptionDetails({super.key, required this.courseID});

  final String courseID;
  final reqMessgaeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final subscriptions = useUserSubscriptions(context);
    final subscriptionsPending = usePendingSubscriptions(context);
    final create = useCreateSubscription(context);

    if (subscriptions.isLoading || subscriptionsPending.isLoading) {
      return LoadingIndicator();
    }

    final subList = subscriptions.data?.data;
    final subListPending = subscriptionsPending.data?.data;
    if (subscriptions.isError ||
        subscriptionsPending.isError ||
        subList == null ||
        subListPending == null) {
      return ErrorAlert();
    }

    SubscriptionDtoWithCourse? subscriptionDetails;
    try {
      subscriptionDetails = subList.firstWhere((e) {
        return e.course.id == courseID;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    SubscriptionDtoWithCourse? subscriptionPendingDetails;
    try {
      subscriptionPendingDetails = subListPending.firstWhere((e) {
        return e.course.id == courseID;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    if (subscriptionDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(
            "Dettagli iscrizione",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
          ),
          _buildSubscriptionInfo(
              "Creato il", subscriptionDetails.createdAt.toLocal().toString())
        ],
      );
    }

    if (subscriptionPendingDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(
            "Dettagli richiesta iscrizione",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
          ),
          _buildSubscriptionInfo("Inviata il",
              subscriptionPendingDetails.createdAt.toLocal().toString())
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text(
          "Invia richiesta iscrizione al fisioterapista",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: TextField(
            controller: reqMessgaeController,
            decoration: InputDecoration(
              labelText: "Messaggio per il fisioterapista (opzionale)",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        FilledButton.icon(
            icon: Icon(Icons.check),
            onPressed: () async {
              await create(SubscriptionRequestDto(
                  courseId: courseID,
                  subscriptionRequestMessage: reqMessgaeController.text));
              if (context.mounted) context.go("/my_courses");
            },
            label: Text("Subscribe")),
      ],
    );
  }

  Widget _buildSubscriptionInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}
