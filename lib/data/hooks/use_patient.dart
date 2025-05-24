import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';

/// ----------------------------------------------------------------
/// MOCK Patient store (in-memory)
/// ----------------------------------------------------------------
Map<String, dynamic>? _mockPatient = {
  'id': 'demo-001',
  'sex': 'Maschio',
  'height': 180.0,
  'weight': 75.0,
  'smoker': false,
  'alcoholUnits': 3.0,
  'activityLevel': 'Intermedio',
  'mobilityLevel': 'Totale',
  'restingHeartRate': 60.0,
  'bloodPressure': '120/80',
  'profession': 'Sviluppatore software',
  'sport': 'Running',
  'sportFrequency': 2.0,
  'medications': '',
  'allergies': 'Noci',
  'otherPathologies': '',
  'painZone': 'Ginocchio',
  'painIntensity': 2.0,
  'painFrequency': 'Occasionale',
  'painCharacteristics': 'Spinoso',
  'painModifiers': 'Riposo',
  'sleepHours': 8.0,
  'perceivedStress': 4.0,
  'lastMedicalCheckup': '2024-10-01',
  'personalGoals': 'Run a marathon',
  'notes': '',
};

/// ----------------------------------------------------------------
/// Query Keys helpers
/// ----------------------------------------------------------------
const patientListKey = ['patients'];
List<Object> detailKey(String id) => ['patient', id];

/// ----------------------------------------------------------------
/// Holder con query + mutation + flag
/// ----------------------------------------------------------------
class PatientManager {
  PatientManager({
    required this.list,
    required this.detail,
    required this.update,
    required this.remove,
  });

  final UseQueryResult<List<Map<String, dynamic>>, dynamic> list;
  final UseQueryResult<Map<String, dynamic>?, dynamic> detail;
  final UseMutationResult<void, Object, Map<String, dynamic>> update;
  final UseMutationResult<void, Object, String> remove;

  bool get isUpdating => update.isPending;
  bool get isDeleting => remove.isPending;
}

/// ----------------------------------------------------------------
/// usePatientManager ⇒ un unico hook: GET list, GET detail, UPDATE, DELETE
/// ----------------------------------------------------------------
PatientManager usePatientMutations(BuildContext context, {String id = 'demo-001'}) {
  final queryClient = useQueryClient();

  // 1️⃣ LIST QUERY ---------------------------------------------------
  final listQuery = useQuery(
    patientListKey,
        () async {
      await Future.delayed(const Duration(milliseconds: 250));
      return _mockPatient != null ? [_mockPatient!] : <Map<String, dynamic>>[];
    },
  );

  // 2️⃣ DETAIL QUERY -------------------------------------------------
  final detailQuery = useQuery(
    detailKey(id),
        () async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (_mockPatient == null || _mockPatient!['id'] != id) return null;
      return _mockPatient;
    },
  );

  // 3️⃣ UPDATE MUTATION ---------------------------------------------
  final update = useMutation<void, Object, Map<String, dynamic>, void>( (
      dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_mockPatient == null) throw Exception('Patient not found');
    _mockPatient!.addAll(dto);
  }, onSuccess: (_, vars, __) {
    queryClient.setQueryData(detailKey(id), _mockPatient as Function(dynamic previous));
    queryClient.invalidateQueries(patientListKey);
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated (mock)')));
    }
  });

  // 4️⃣ DELETE MUTATION ---------------------------------------------
  final delete = useMutation<void, Object, String, void>( (
      pid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_mockPatient == null || _mockPatient!['id'] != pid) throw Exception('Patient not found');
    _mockPatient = null;
  }, onSuccess: (_, pid, __) {
    queryClient.invalidateQueries(patientListKey);
    queryClient.invalidateQueries(detailKey(pid));
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile deleted (mock)')));
    }
  });

  return PatientManager(
    list:   listQuery,
    detail: detailQuery,
    update: update,
    remove: delete,
  );
}

