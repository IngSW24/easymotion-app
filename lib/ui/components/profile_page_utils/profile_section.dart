import 'package:easymotion_app/ui/components/profile_page_utils/profile_field_view.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/section_card.dart';
import 'package:flutter/material.dart';

import '../../Theme/theme.dart';
import 'field_descriptor.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<FieldDefinition> schema;
  final Map<String, dynamic> data;
  final VoidCallback onEdit;

  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.schema,
    required this.data,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      icon: icon,
      iconColor: Colors.white,
      backgroundColor: DesignTokens.primaryBlue,
      foregroundTextColor: Colors.white,
      editButtonColor: Colors.white,
      onEdit: onEdit,
      children: [
        for (final def in schema)
          ProfileFieldView(
            definition: def,
            dataSource: data,
          ),
      ],
    );
  }
}
