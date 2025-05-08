import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_api.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';

const String coursesSubscribedQueryKey = "courses_subscribed";
const String subscriptionsQueryKey = "subscriptions";
const String subscriptionsPendingQueryKey = "subscriptions_pending";

UseQueryResult<PaginatedResponseOfCourseDto?, dynamic> useCoursesSubscribed(
    BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  final userID = apiProvider.getUser()?.id;
  return useQuery(
      [coursesSubscribedQueryKey],
      () async => (await apiProvider.schema.coursesSubscribedUserIdGet(
              page: 0, perPage: 100, userId: userID))
          .body);
}

UseQueryResult<PaginatedResponseOfSubscriptionDtoWithCourse?, dynamic>
    useUserSubscriptions(BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  return useQuery(
      [subscriptionsQueryKey],
      () async =>
          (await apiProvider.schema.subscriptionsGet(page: 0, perPage: 10))
              .body);
}

UseQueryResult<PaginatedResponseOfSubscriptionDtoWithCourse?, dynamic>
    usePendingSubscriptions(BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  return useQuery(
      [subscriptionsPendingQueryKey],
      () async => (await apiProvider.schema
              .subscriptionsPendingGet(page: 0, perPage: 10))
          .body);
}

Future<void> Function(SubscriptionRequestDto sub) useCreateSubscription(
    BuildContext ctx) {
  final queryClient = useQueryClient();
  final api = useApi(ctx);

  return (SubscriptionRequestDto sub) async {
    await api.schema.subscriptionsRequestPost(body: sub);
    queryClient.invalidateQueries([
      coursesSubscribedQueryKey,
    ]);
    queryClient.invalidateQueries([
      subscriptionsQueryKey,
    ]);
    queryClient.invalidateQueries([subscriptionsPendingQueryKey]);
  };
}
