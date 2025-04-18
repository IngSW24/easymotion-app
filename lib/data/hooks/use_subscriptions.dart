import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_api.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';

const String coursesSubscribedQueryKey = "courses_subscribed";
const String subscriptionsQueryKey = "subscriptions";

UseQueryResult<PaginatedResponseOfCourseDto?, dynamic> useCoursesSubscribed(
    BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  final userID = apiProvider.getUser()?.id;
  return useQuery(
      [coursesSubscribedQueryKey],
      refetchInterval: Duration(seconds: 3),
      () async => (await apiProvider.schema.coursesSubscribedUserIdGet(
              page: 0, perPage: 100, userId: userID))
          .body);
}

UseQueryResult<PaginatedResponseOfSubscriptionDto?, dynamic>
    useUserSubscriptions(BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  return useQuery(
      [subscriptionsQueryKey],
      refetchInterval: Duration(seconds: 3),
      () async =>
          (await apiProvider.schema.subscriptionsGet(page: 0, perPage: 100))
              .body);
}

Future<void> Function(SubscriptionCreateDto sub) useCreateSubscription(
    BuildContext ctx) {
  final queryClient = useQueryClient();
  final api = useApi(ctx);

  return (SubscriptionCreateDto sub) async {
    await api.schema.subscriptionsPost(body: sub);
    queryClient
        .invalidateQueries([coursesSubscribedQueryKey, subscriptionsQueryKey]);
  };
}

Future<void> Function(SubscriptionDeleteDto sub) useDeleteSubscription(
    BuildContext ctx) {
  final queryClient = useQueryClient();
  final api = useApi(ctx);

  return (SubscriptionDeleteDto sub) async {
    await api.schema.subscriptionsDelete(body: sub);
    queryClient
        .invalidateQueries([coursesSubscribedQueryKey, subscriptionsQueryKey]);
  };
}
