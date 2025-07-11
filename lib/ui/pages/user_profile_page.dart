import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:easymotion_app/ui/pages/loading_page.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/user_profile_schema/schemas.dart';
import '../../data/hooks/use_patient.dart';
import '../Theme/theme.dart';
import '../components/profile_page_utils/field_descriptor.dart';
import '../components/profile_page_utils/profile_avatar.dart';
import '../components/profile_page_utils/profile_section.dart';
import '../components/profile_page_utils/user_profile_modal/profile_edit_modal.dart';
import '../components/utility/button.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = useUserInfo(context).call()!;
    final patient = usePatient(context, user.id);
    final logoutFn = useLogoutFn(context);

    if (patient.query.isLoading) return const LoadingPage();

    Map<String, dynamic> buildSectionMap(
        List<FieldDefinition> schema, AuthUserDto? user) {
      final userMap = user?.toJson() ?? {};
      final patientMap = userMap['patient'] ?? {};

      return {
        for (final def in schema)
          def.key: def.location == FieldLocation.root
              ? userMap[def.key]
              : patientMap[def.key]
      };
    }

    final personalMap = buildSectionMap(personalSchema, patient.query.data);
    final healthMap = buildSectionMap(healthSchema, patient.query.data);

    void handleEdit(String title, List<FieldDefinition> schema) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EditModalProfile(
          title: title,
          schema: schema,
          initialData: patient.query.data!,
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
                '${patient.query.data?.firstName ?? ''} ${patient.query.data?.lastName ?? ''}',
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
                data: healthMap,
                onEdit: () =>
                    handleEdit('Informazioni sanitarie', healthSchema),
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
