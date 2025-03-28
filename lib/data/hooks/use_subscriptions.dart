import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';

const String subscriptionQueryKey = "subscription";

UseQueryResult<PaginatedResponseOfCourseEntity?, dynamic> useCoursesSubscribed(
    BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  final userID = apiProvider.getUser()?.id;
  return useQuery(
      [subscriptionQueryKey],
      () async => (await apiProvider.schema.coursesSubscribedUserIdGet(
              page: 0, perPage: 100, userId: userID))
          .body);
}

UseQueryResult<PaginatedResponseOfSubscriptionDto?, dynamic>
    useUserSubscriptions(BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  return useQuery(
      [subscriptionQueryKey],
      () async =>
          (await apiProvider.schema.subscriptionsGet(page: 0, perPage: 100))
              .body);
}
