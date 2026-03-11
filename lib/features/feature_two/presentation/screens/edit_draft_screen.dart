import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_segmented_control.dart';

class EditDraftScreen extends ConsumerStatefulWidget {
  final String draftId;
  const EditDraftScreen({super.key, required this.draftId});

  @override
  ConsumerState<EditDraftScreen> createState() => _EditDraftScreenState();
}

class _EditDraftScreenState extends ConsumerState<EditDraftScreen> {
  String _disease = 'Malaria';
  String _location = 'Tema Metro';
  int _severityIndex = 1;
  String _notes = 'Patients presented with fever and chills at Tema General. Two admitted for monitoring.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                children: [
                  _sectionHeader('Disease Information'),
                  _dropdownField('Disease *', _disease, AppConstants.diseases, (v) => setState(() => _disease = v!)),
                  _dropdownField('Location *', _location, AppConstants.locations, (v) => setState(() => _location = v!)),
                  Row(
                    children: [
                      Expanded(child: _textField('Date *', initialValue: '2026-02-28')),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(child: _textField('Time', initialValue: '10:30')),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _sectionHeader('Case Details'),
                  _textField('Case Count *', initialValue: '4', keyboardType: TextInputType.number),
                  Row(
                    children: [
                      Expanded(child: _dropdownField('Sex', 'Male', AppConstants.sexOptions, (_) {})),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(child: _dropdownField('Age Group', '18–59', AppConstants.ageGroups, (_) {})),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text('Severity', style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.s1),
                  AppSegmentedControl(
                    segments: AppConstants.severities,
                    selectedIndex: _severityIndex,
                    onChanged: (i) => setState(() => _severityIndex = i),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _dropdownField('Report Source', 'Facility', AppConstants.reportSources, (_) {}),
                  const SizedBox(height: AppSpacing.s4),
                  _sectionHeader('Additional Notes'),
                  _textFieldMulti('Case Notes', _notes, (v) => setState(() => _notes = v)),
                  const SizedBox(height: AppSpacing.s4),
                  _draftSubmitHint(),
                  const SizedBox(height: AppSpacing.s4),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Wire to reportsRepository.updateReport() with status = SUBMITTED
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted')));
                        context.go('/my-submissions');
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Submit Report'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: AppRadius.borderBase)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Wire to reportsRepository.updateReport() with status = DRAFT
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved')));
                        context.pop();
                      },
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Save as Draft'),
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: AppRadius.borderBase)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: Text('Cancel — return to My Submissions', style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
      child: Row(
        children: [
          AppIconButton(icon: Icons.arrow_back_rounded, showBorder: false, onTap: () => context.pop()),
          const SizedBox(width: AppSpacing.s2),
          Expanded(child: Text('Edit Draft', style: AppTypography.appBarTitle)),
          const AppBadge(label: 'DRAFT', variant: BadgeVariant.warning),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Row(
        children: [
          Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.primary)),
          const SizedBox(width: AppSpacing.s3),
          const Expanded(child: Divider(color: AppColors.border)),
        ],
      ),
    );
  }

  Widget _dropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s1),
          DropdownButtonFormField<String>(
            initialValue: items.contains(value) ? value : null,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _textField(String label, {String? initialValue, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s1),
          TextFormField(initialValue: initialValue, keyboardType: keyboardType, decoration: const InputDecoration()),
        ],
      ),
    );
  }

  Widget _textFieldMulti(String label, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s1),
          TextFormField(initialValue: value, maxLines: 3, onChanged: onChanged, decoration: const InputDecoration()),
        ],
      ),
    );
  }

  Widget _draftSubmitHint() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.primaryXLight,
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.info_outline_rounded, size: 13, color: AppColors.primary),
            const SizedBox(width: 4),
            Text('Draft vs Submit', style: AppTypography.overline.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 3),
          const Text(
            'Save as Draft — keeps this report editable. Come back and finish later.\nSubmit Report — locks this report. It cannot be edited once submitted.',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
