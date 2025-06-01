import 'package:easymotion_app/data/hooks/use_patient.dart';
import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../api-client-generated/api_schema.models.swagger.dart';
import '../../../Theme/theme.dart';
import '../../utility/button.dart';
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

    // Controller per i campi
    final controller = useMemoized(
      () => ProfileEditController(
        schema: schema,
        initialData: initialData,
      ),
      [schema, initialData],
    );

    // Cleanup dei controller quando il widget viene distrutto
    useEffect(() {
      return () => controller.dispose();
    }, []);

    // Query & mutation del paziente loggato
    final user = useUserInfo(context).call()!;
    final patient = usePatient(context, user.id);

    // Stato di salvataggio per disabilitare il tasto e mostrare feedback
    final isSaving = useState(false);

    // Effetto per aggiornare i controller quando i dati cambiano
    useEffect(() {
      if (patient.query.data != null) {
        controller.updateControllers(patient.query.data!);
      }
      return null;
    }, [patient.query.data]);

    void handleSave() async {
      if (isSaving.value) return; // evita tap multipli
      if (!controller.validate()) return; // campi non validi

      isSaving.value = true;

      try {
        final dto = controller.collectUpdates();
        final update = UpdateAuthUserDto.fromJson(dto.toJson());

        print('=== DEBUG MUTATION ===');
        print('1. DTO prima della mutation:');
        print(dto.toJson());
        print('2. Update DTO prima della mutation:');
        print(update.toJson());

        // 1. mutation REST
        await patient.update.mutate(update);
        print('3. Mutation completata');

        print('4. Dati della query dopo mutation:');
        print(patient.query.data?.toJson());

        // 2. refetch della query per propagare i nuovi dati a chi ascolta
        await patient.query.refetch();

        print('5. Dati della query dopo refetch:');
        print(patient.query.data?.toJson());
        print('=== FINE DEBUG ===');

        // 3. chiudi il modal restituendo un flag di riuscita
        if (context.mounted) {
          Navigator.pop(context, true);
          // Forza un rebuild della pagina principale
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profilo aggiornato con successo'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Errore durante il salvataggio: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isSaving.value = false;
      }
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: insets.bottom),
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    label: isSaving.value ? 'Saving…' : 'Save',
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
