import 'package:flutter/cupertino.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';

import '../../api-client-generated/api_schema.models.swagger.dart';
import '../providers/api.provider.dart';

const String patientQueryKey = "patient";

class Patient {
  Patient({
    required this.query,
    required this.update,
  });

  final UseQueryResult<AuthUserDto?, dynamic> query;
  final UseMutationResult<AuthUserDto, dynamic, UpdateAuthUserDto> update;
}

Patient usePatient(BuildContext ctx, String id) {
  final api = Provider.of<ApiProvider>(ctx, listen: false);
  final queryClient = useQueryClient();

  final query = useQuery<AuthUserDto?, dynamic>(
    [patientQueryKey, id],
        () async => (await api.schema.profileGet()).body,
  );

  final update = useMutation<AuthUserDto, dynamic, UpdateAuthUserDto, void>(
        (updatedPatient) async {
      final res = await api.schema.profilePut(
        body: updatedPatient,
      );
      return res.body!;
    },
    onSuccess: (newDto, variables, context) {
      queryClient.setQueryData(
        [patientQueryKey, id],
        (_) => newDto,
      );
    },
  );

  return Patient(
    query: query,
    update: update,
  );
}
