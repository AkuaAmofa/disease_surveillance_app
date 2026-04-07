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
  final _deathCountController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  final _healthFacilityController = TextEditingController();

  // Sex breakdown
  final _maleCountController = TextEditingController(text: '0');
  final _femaleCountController = TextEditingController(text: '0');
  final _unknownSexCountController = TextEditingController(text: '0');

  // Age breakdown
  final _ageUnder5Controller = TextEditingController(text: '0');
  final _age5To17Controller = TextEditingController(text: '0');
  final _age18To59Controller = TextEditingController(text: '0');
  final _age60PlusController = TextEditingController(text: '0');
  final _unknownAgeController = TextEditingController(text: '0');

  int _formVersion = 0;
  bool _didPrefill = false;

  @override
  void dispose() {
    _caseCountController.dispose();
    _deathCountController.dispose();
    _notesController.dispose();
    _healthFacilityController.dispose();
    _maleCountController.dispose();
    _femaleCountController.dispose();
    _unknownSexCountController.dispose();
    _ageUnder5Controller.dispose();
    _age5To17Controller.dispose();
    _age18To59Controller.dispose();
    _age60PlusController.dispose();
    _unknownAgeController.dispose();
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
    _deathCountController.text = '0';
    _notesController.clear();
    _healthFacilityController.clear();
    _maleCountController.text = '0';
    _femaleCountController.text = '0';
    _unknownSexCountController.text = '0';
    _ageUnder5Controller.text = '0';
    _age5To17Controller.text = '0';
    _age18To59Controller.text = '0';
    _age60PlusController.text = '0';
    _unknownAgeController.text = '0';
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
        _deathCountController.text = formState.deathCount.toString();
        _notesController.text = formState.notes;
        _healthFacilityController.text = formState.healthFacility;
        _maleCountController.text = formState.maleCount.toString();
        _femaleCountController.text = formState.femaleCount.toString();
        _unknownSexCountController.text = formState.unknownSexCount.toString();
        _ageUnder5Controller.text = formState.ageUnder5Count.toString();
        _age5To17Controller.text = formState.age5To17Count.toString();
        _age18To59Controller.text = formState.age18To59Count.toString();
        _age60PlusController.text = formState.age60PlusCount.toString();
        _unknownAgeController.text = formState.unknownAgeCount.toString();
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

          // ── Section 2: IDSR Classification ──────────────────
          const _SectionHeader(title: 'IDSR Classification'),

          _DropdownField(
            label: 'Case Classification *',
            value: formState.caseClassification,
            items: AppConstants.caseClassifications,
            onChanged: (v) => controller.setCaseClassification(v ?? 'Unknown'),
          ),

          _DropdownField(
            label: 'Report Type *',
            value: formState.reportType,
            items: AppConstants.reportTypes,
            onChanged: (v) => controller.setReportType(v ?? 'Weekly'),
            helperText: 'Use Immediate for cholera, VHF, AFP, meningitis — required within 24–48 hours',
          ),

          const SizedBox(height: AppSpacing.s4),

          // ── Section 3: Case Details ─────────────────────────
          const _SectionHeader(title: 'Case Details'),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InputField(
                  label: 'Case Count *',
                  hint: '1',
                  controller: _caseCountController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.setCaseCount(int.tryParse(v) ?? 1),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: _InputField(
                  label: 'Deaths',
                  hint: '0',
                  controller: _deathCountController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.setDeathCount(int.tryParse(v) ?? 0),
                ),
              ),
            ],
          ),

          _InputField(
            label: 'Health Facility',
            hint: 'e.g. Korle Bu Teaching Hospital',
            controller: _healthFacilityController,
            onChanged: controller.setHealthFacility,
          ),

          // Sex breakdown
          _BreakdownSection(
            title: 'Sex Breakdown',
            total: formState.sexTotal,
            caseCount: formState.caseCount,
            children: [
              _CountField(
                label: 'Male',
                controller: _maleCountController,
                onChanged: (v) => controller.setMaleCount(v),
              ),
              _CountField(
                label: 'Female',
                controller: _femaleCountController,
                onChanged: (v) => controller.setFemaleCount(v),
              ),
              _CountField(
                label: 'Unknown',
                controller: _unknownSexCountController,
                onChanged: (v) => controller.setUnknownSexCount(v),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s4),

          // Age breakdown
          _BreakdownSection(
            title: 'Age Breakdown',
            total: formState.ageTotal,
            caseCount: formState.caseCount,
            children: [
              _CountField(
                label: 'Under 5',
                controller: _ageUnder5Controller,
                onChanged: (v) => controller.setAgeUnder5Count(v),
              ),
              _CountField(
                label: '5–17',
                controller: _age5To17Controller,
                onChanged: (v) => controller.setAge5To17Count(v),
              ),
              _CountField(
                label: '18–59',
                controller: _age18To59Controller,
                onChanged: (v) => controller.setAge18To59Count(v),
              ),
              _CountField(
                label: '60+',
                controller: _age60PlusController,
                onChanged: (v) => controller.setAge60PlusCount(v),
              ),
              _CountField(
                label: 'Unknown',
                controller: _unknownAgeController,
                onChanged: (v) => controller.setUnknownAgeCount(v),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s4),

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

          // ── Section 4: Additional Notes ─────────────────────
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

/// Wraps a group of count inputs with a section label and live total indicator.
class _BreakdownSection extends StatelessWidget {
  final String title;
  final int total;
  final int caseCount;
  final List<Widget> children;

  const _BreakdownSection({
    required this.title,
    required this.total,
    required this.caseCount,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasEntries = total > 0;
    final bool isValid = !hasEntries || total == caseCount;
    final Color totalColor = hasEntries
        ? (isValid ? AppColors.success : AppColors.danger)
        : AppColors.textMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppTypography.overline.copyWith(color: AppColors.textSecondary),
            ),
            const Spacer(),
            Text(
              'Total: $total / $caseCount',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: totalColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: children
              .map((c) => Expanded(child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.s2),
                    child: c,
                  )))
              .toList(),
        ),
      ],
    );
  }
}

/// Compact integer count input with a label above.
class _CountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  const _CountField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
          onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
          decoration: const InputDecoration(
            hintText: '0',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          ),
        ),
      ],
    );
  }
}

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
  final String? helperText;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    this.value,
    required this.items,
    this.hint,
    this.helperText,
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
            decoration: InputDecoration(
              helperText: helperText,
              helperMaxLines: 2,
            ),
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
              decoration: const InputDecoration(
                hintText: 'Select date',
                suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
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
              decoration: const InputDecoration(
                hintText: 'HH:MM',
                suffixIcon: Icon(Icons.access_time_rounded, size: 18),
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
