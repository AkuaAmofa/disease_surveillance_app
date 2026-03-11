import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/repositories/profile_repository.dart';
import '../controllers/profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(profileUserProvider).valueOrNull;
    if (user == null || user.id == 0) {
      setState(() => _errorMessage = 'Cannot resolve user ID. Try again.');
      return;
    }

    final newName = _nameController.text.trim();
    if (newName == user.name) {
      if (mounted) context.pop();
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(profileRepositoryProvider)
          .updateProfile(user.id, {'name': newName});

      ref.invalidate(profileUserProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')),
        );
        context.pop();
      }
    } on ApiException catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Failed to save. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(profileUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Could not load profile: $err', style: AppTypography.caption),
        ),
        data: (user) {
          if (_nameController.text.isEmpty && user.name.isNotEmpty) {
            _nameController.text = user.name;
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: Text(
                          user.initials,
                          style: AppTypography.headingLg.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  Text(
                    'FULL NAME',
                    style: AppTypography.overline,
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your full name',
                    ),
                  ),
                  if (user.email.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s4),
                    Text('EMAIL', style: AppTypography.overline),
                    const SizedBox(height: AppSpacing.s2),
                    TextFormField(
                      initialValue: user.email,
                      enabled: false,
                      decoration: const InputDecoration(),
                    ),
                  ],
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.s3),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.s3),
                      decoration: BoxDecoration(
                        color: AppColors.dangerBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.dangerBorder),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: AppTypography.caption.copyWith(color: AppColors.danger),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s6),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
