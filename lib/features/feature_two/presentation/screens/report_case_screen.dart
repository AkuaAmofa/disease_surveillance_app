import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../controllers/reports_controller.dart';

class ReportCaseScreen extends ConsumerStatefulWidget {
  final int? editReportId;
  const ReportCaseScreen({super.key, this.editReportId});

  @override
  ConsumerState<ReportCaseScreen> createState() => _ReportCaseScreenState();
}

class _ReportCaseScreenState extends ConsumerState<ReportCaseScreen> {
  final _caseCountController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  int _formVersion = 0;
  bool _didPrefill = false;

  @override
  void dispose() {
    _caseCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderBase),
        icon: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
        title: const Text('Report Submitted'),
        content: const Text(
          'Your case report has been submitted successfully and is now available on the surveillance dashboard.',
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          if (widget.editReportId == null)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _resetForm();
              },
              child: const Text('Submit Another'),
            ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (Navigator.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/my-submissions');
              }
            },
            child: Text(widget.editReportId != null ? 'Back to Submissions' : 'View Reports'),
          ),
        ],
      ),
    );
  }

  void _onDraftSaved() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saved successfully.')),
    );
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/my-submissions');
    }
  }

  void _resetForm() {
    ref.read(reportFormProvider(widget.editReportId).notifier).resetForm();
    _caseCountController.text = '1';
    _notesController.clear();
    _didPrefill = false;
    setState(() => _formVersion++);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(reportFormProvider(widget.editReportId));
    final controller = ref.read(reportFormProvider(widget.editReportId).notifier);

    ref.listen<ReportFormState>(reportFormProvider(widget.editReportId), (prev, next) {
      if (next.isSuccess && !(prev?.isSuccess ?? false)) {
        _showSuccessDialog();
      }
      if (next.isDraftSaved && !(prev?.isDraftSaved ?? false)) {
        _onDraftSaved();
      }
    });

    // Sync text controllers when edit data loads
    if (!_didPrefill && !formState.isLoadingData && formState.isEditMode) {
      _didPrefill = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _caseCountController.text = formState.caseCount.toString();
        _notesController.text = formState.notes;
        setState(() => _formVersion++);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(formState.isEditMode),
            Expanded(child: _buildBody(formState, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isEditMode) {
    final canGoBack = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: [
          if (canGoBack) ...[
            AppIconButton(
              icon: Icons.arrow_back_rounded,
              showBorder: false,
              onTap: () => context.pop(),
            ),
            const SizedBox(width: AppSpacing.s2),
          ],
          Expanded(
            child: Text(
              isEditMode ? 'Edit Draft' : 'Report Case',
              style: AppTypography.appBarTitle,
            ),
          ),
          if (isEditMode)
            const AppBadge(label: 'DRAFT', variant: BadgeVariant.warning),
        ],
      ),
    );
  }

  Widget _buildBody(ReportFormState formState, ReportFormController controller) {
    if (formState.isLoadingData) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.s4),
            Text('Loading form data...'),
          ],
        ),
      );
    }

    if (formState.diseases.isEmpty && formState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textMuted),
              const SizedBox(height: AppSpacing.s4),
              Text(
                formState.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s4),
              FilledButton.icon(
                onPressed: controller.loadReferenceData,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      key: ValueKey(_formVersion),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (formState.errorMessage != null) ...[
            _ErrorBanner(message: formState.errorMessage!),
            const SizedBox(height: AppSpacing.s4),
          ],

          // ── Section 1: Disease Information ──────────────────
          const _SectionHeader(title: 'Disease Information'),

          _DropdownField(
            label: 'Disease *',
            value: formState.selectedDisease,
            items: formState.diseases.map((d) => d.name).toList(),
            hint: 'Select disease...',
            onChanged: (v) {
              if (v != null) controller.setDisease(v);
            },
          ),

          _DropdownField(
            label: 'Location *',
            value: formState.selectedLocation,
            items: formState.locations.map((l) => l.name).toList(),
            hint: 'Select location...',
            onChanged: (v) {
              if (v != null) controller.setLocation(v);
            },
          ),

          Row(
            children: [
              Expanded(
                child: _DatePickerField(
                  label: 'Date *',
                  value: formState.date,
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: formState.date ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (d != null) controller.setDate(d);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: _TimePickerField(
                  label: 'Time',
                  value: formState.time,
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: formState.time ?? TimeOfDay.now(),
                    );
                    if (t != null) controller.setTime(t);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s4),

          // ── Section 2: Case Details ─────────────────────────
          const _SectionHeader(title: 'Case Details'),

          _InputField(
            label: 'Case Count *',
            hint: '1',
            controller: _caseCountController,
            keyboardType: TextInputType.number,
            onChanged: (v) => controller.setCaseCount(int.tryParse(v) ?? 1),
          ),

          Row(
            children: [
              Expanded(
                child: _DropdownField(
                  label: 'Sex',
                  value: formState.sex,
                  items: AppConstants.sexOptions,
                  onChanged: (v) => controller.setSex(v ?? 'Unknown'),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: _DropdownField(
                  label: 'Age Group',
                  value: formState.ageGroup,
                  items: AppConstants.ageGroups,
                  onChanged: (v) => controller.setAgeGroup(v ?? 'Unknown'),
                ),
              ),
            ],
          ),

          Text(
            'Severity',
            style: AppTypography.overline.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s1),
          AppSegmentedControl(
            segments: AppConstants.severities,
            selectedIndex: AppConstants.severities.indexOf(formState.severity).clamp(0, AppConstants.severities.length - 1),
            onChanged: (i) => controller.setSeverity(AppConstants.severities[i]),
          ),
          const SizedBox(height: AppSpacing.s4),

          _DropdownField(
            label: 'Report Source',
            value: formState.reportSource,
            items: AppConstants.reportSources,
            onChanged: (v) => controller.setSource(v ?? 'Facility'),
          ),

          const SizedBox(height: AppSpacing.s4),

          // ── Section 3: Additional Notes ─────────────────────
          const _SectionHeader(title: 'Additional Notes'),

          _InputField(
            label: 'Case Notes',
            hint: 'Optional notes about this case...',
            maxLines: 4,
            controller: _notesController,
            onChanged: controller.setNotes,
          ),

          const SizedBox(height: AppSpacing.s2),

          // ── Draft/Submit hint ───────────────────────────────
          _DraftSubmitHint(),

          const SizedBox(height: AppSpacing.s4),

          // ── Submit Button ───────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: formState.isSubmitting ? null : () => controller.submit(),
              icon: formState.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                formState.isEditMode ? 'Submit Report' : 'Submit Case',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderBase),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s3),

          // ── Save as Draft Button ────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: formState.isSubmitting ? null : () => controller.saveAsDraft(),
              icon: const Icon(Icons.save_rounded, size: 18),
              label: const Text('Save as Draft'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderBase),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Private widgets
// ═══════════════════════════════════════════════════════════════════

class _DraftSubmitHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          const Expanded(child: Divider(color: AppColors.border)),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String? hint;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    this.value,
    required this.items,
    this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.overline.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s1),
          DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            hint: hint != null
                ? Text(hint!, style: const TextStyle(color: AppColors.textPlaceholder))
                : null,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const _InputField({
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.overline.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s1),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final display = value != null ? DateFormat('dd/MM/yyyy').format(value!) : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.overline.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s1),
          GestureDetector(
            onTap: onTap,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'Select date',
                suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
              ),
              child: display != null ? Text(display) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final VoidCallback onTap;

  const _TimePickerField({
    required this.label,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final display = value != null
        ? '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}'
        : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.overline.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s1),
          GestureDetector(
            onTap: onTap,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'HH:MM',
                suffixIcon: const Icon(Icons.access_time_rounded, size: 18),
              ),
              child: display != null ? Text(display) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: AppColors.dangerBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.danger),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: AppColors.danger, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
