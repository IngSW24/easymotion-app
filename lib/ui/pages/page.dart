import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:easymotion_app/ui/pages/loading_page.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/user_profile_schema/schemas.dart';
import '../../data/hooks/new.dart';
import '../Theme/Theme.dart';
import '../components/profile_page_utils/field_descriptor.dart';
import '../components/profile_page_utils/profile_avatar.dart';
import '../components/profile_page_utils/profile_section.dart';
import '../components/profile_page_utils/user_profile_modal/profile_edit_modal.dart';
import '../components/profile_page_utils/user_profile_schema/healthy_profile_initializer.dart';
import '../components/utility/button.dart';

class NuovaProfilePage extends HookWidget {
  const NuovaProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = useUserInfo(context).call()!;
    final patient = usePatient(context, user.id);
    final logoutFn = useLogoutFn(context);

    final blank = useMemoized(buildEmptyProfile);
    final patientDto = patient.query.data?.patient;

    if (patient.query.isLoading) return const LoadingPage();

    final merged = useMemoized(() => {
      ...blank,
      ...user.toJson(),
      ...(patientDto?.toJson() ?? {}),
    }, [user, patientDto]);

    final formData = useState<Map<String, dynamic>>(merged);

    final personalMap = <String, dynamic>{
      'firstName' : patient.query.data?.firstName,
      'middleName': patient.query.data?.middleName,
      'lastName'  : patient.query.data?.lastName,
      'email'     : patient.query.data?.email,
      'birthDate' : patient.query.data?.birthDate,
    };

    final healthMap = patientDto?.toJson() ?? {};

    void handleEdit(String title, List<FieldDefinition> schema) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EditModalProfile(
          title: title,
          schema: schema,
          initialData: patient.query.data!.toJson(), //formData.value;
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              const ProfileAvatar(),
              const SizedBox(height: 16),
              Text(
                //'${formData.value["firstName"]} ${formData.value["lastName"]}',
                '${patient.query.data?.firstName} ${patient.query.data?.lastName}',
                style: DesignTokens.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ProfileSection(
                title: 'Informazioni personali',
                icon: Icons.person,
                schema: personalSchema,
                data: personalMap,
                onEdit: () => handleEdit(
                  'Informazioni personali',
                  personalSchema,
                ),
              ),
              const SizedBox(height: 24),
              ProfileSection(
                title: 'Informazioni sanitarie',
                icon: Icons.favorite,
                schema: healthSchema,
                //data: formData.value, CAMBIATO
                data: healthMap,
                onEdit: () => handleEdit('Informazioni sanitarie', healthSchema),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Button(
                  label: 'Logout',
                  onPressed: logoutFn,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Grazie da',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Easymotion',
                style: TextStyle(
                  color: DesignTokens.primaryBlue,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
