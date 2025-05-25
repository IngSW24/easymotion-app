import 'package:easymotion_app/data/hooks/new.dart';
import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../api-client-generated/api_schema.models.swagger.dart';
import '../../../Theme/Theme.dart';
import '../../utility/Button.dart';
import '../field_descriptor.dart';
import 'field_builder.dart';
import 'profile_edit_controller.dart';

class EditModalProfile extends HookWidget {
  const EditModalProfile({
    super.key,
    required this.title,
    required this.schema,
    required this.initialData,
  });

  final String title;
  final List<FieldDefinition> schema;
  final AuthUserDto initialData;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets;
    final controller = useMemoized(
          () => ProfileEditController(
        schema: schema,
        initialData: initialData,
      ),
      [schema, initialData],
    );
    final user   = useUserInfo(context).call()!;
    final patient = usePatient(context, user.id);

    void handleSave () async {
      if (!controller.validate()) return;

      final AuthUserDto updated = controller.collectUpdates();

      final update = UpdateAuthUserDto.fromJson(updated.toJson());

      final sispera = update.toJson();
      print("UPDATE $sispera");
      patient.update.mutate(update);
      print(patient.query.refetch);
      print(patient.query.data);
      if (context.mounted) Navigator.pop(context);
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: insets.bottom),
        child: Material(
          color: Colors.white,
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(24)),
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 24),

                  for (final def in controller.schema) ...[
                    FieldBuilder(controller: controller, def: def),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 8),
                  Button(
                    label: 'Save',
                    background: DesignTokens.primaryBlue,
                    foreground: Colors.white,
                    onPressed: handleSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}