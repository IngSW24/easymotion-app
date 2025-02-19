import 'package:fquery/fquery.dart';

import 'package:easymotion_app/api-client-generated/lib/api.dart';

UseQueryResult<PaginatedResponseOfCourseEntity?, Exception> useCourses(
    CoursesApi coursesApi) {
  return useQuery<PaginatedResponseOfCourseEntity?, Exception>(
      ["courses"],
      () async =>
          await coursesApi.coursesControllerFindAll(page: 0, perPage: 100));
}
