import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../data/common/datetime/datetime2local.dart';

class SubscriptionDetails extends HookWidget {
  SubscriptionDetails({super.key, required this.courseDetails});

  final CourseDto courseDetails;
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
        return e.course.id == courseDetails.id;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    SubscriptionDtoWithCourse? subscriptionPendingDetails;
    try {
      subscriptionPendingDetails = subListPending.firstWhere((e) {
        return e.course.id == courseDetails.id;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    if (subscriptionDetails != null) {
      return _buildSubscriptionDetails(subscriptionDetails);
    }

    if (subscriptionPendingDetails != null) {
      return _buildSubscriptionPendingDetails(subscriptionPendingDetails);
    }

    return _buildCreateSubscriptionDetails(create);
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

  Widget _buildSubscriptionDetails(
      SubscriptionDtoWithCourse subscriptionDetails) {
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
            "Creato il", datetime2local((subscriptionDetails.createdAt)))
      ],
    );
  }

  Widget _buildSubscriptionPendingDetails(
      SubscriptionDtoWithCourse subscriptionPendingDetails) {
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
        _buildSubscriptionInfo(
            "Inviata il", datetime2local(subscriptionPendingDetails.createdAt))
      ],
    );
  }

  String _getAvailableSlots(CourseDto course) {
    return courseDetails.maxSubscribers == null
        ? "Nessun limite"
        : "${(courseDetails.maxSubscribers! - courseDetails.currentSubscribers).toInt()}/${courseDetails.maxSubscribers!.toInt()}";
  }

  String _getAvailableTime(CourseDto course) {
    final seconds =
        course.subscriptionEndDate.difference(DateTime.now()).inSeconds;
    if (seconds > (Duration.secondsPerHour * Duration.hoursPerDay)) {
      final hours = seconds ~/ (Duration.secondsPerHour * Duration.hoursPerDay);
      return "$hours giorni";
    }

    if (seconds > Duration.secondsPerHour) {
      final hours = seconds ~/ Duration.secondsPerHour;
      return "$hours ore";
    }

    if (seconds > Duration.secondsPerMinute) {
      final minutes = seconds ~/ Duration.secondsPerMinute;
      return "$minutes minuti";
    }
    return "$seconds secondi";
  }

  Widget _buildCreateSubscriptionDetails(
      Future<void> Function(SubscriptionRequestDto) create) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text(
          "Informazione sull'iscrizione",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
        ),
        _buildSubscriptionInfo(
            "Iscritti", courseDetails.currentSubscribers.toInt().toString()),
        _buildSubscriptionInfo(
            "Posti disponibili", _getAvailableSlots(courseDetails)),
        _buildSubscriptionInfo("Apertura iscrizioni",
            datetime2local(courseDetails.subscriptionStartDate)),
        _buildSubscriptionInfo("Chiusura iscrizioni",
            datetime2local(courseDetails.subscriptionEndDate)),
        _buildSubscriptionInfo(
            "Le iscrizioni scadono fra", _getAvailableTime(courseDetails)),
        if (courseDetails.subscriptionEndDate.isAfter(DateTime.now()))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Text(
                "Invia la richiesta di iscrizione al fisioterapista",
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
              Align(
                alignment: Alignment.bottomRight,
                child: FilledButton.icon(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      await create(SubscriptionRequestDto(
                          courseId: courseDetails.id,
                          subscriptionRequestMessage:
                              reqMessgaeController.text));
                    },
                    label: Text("Iscriviti")),
              ),
            ],
          )
      ],
    );
  }
}
