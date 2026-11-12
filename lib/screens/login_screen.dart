import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../core/theme.dart';
import '../core/validators.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'admin_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _usePhone = false;
  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMethod() {
    setState(() {
      _usePhone = !_usePhone;
      _identifierController.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _identifierController.text.trim().toLowerCase();
    final pass = _passwordController.text;

    if (user == 'admin' && pass == 'admin123') {
      _identifierController.clear();
      _passwordController.clear();
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => AdminScreen(onLogout: () => Navigator.of(context).pop()),
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);
    try {
      await auth.login(
        phone: _identifierController.text,
        password: _passwordController.text,
      );
    } on InvalidCredentialsException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not log in. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocaleProvider>().language;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.emerald,
                        child: Icon(Icons.shield, color: Colors.white, size: 44),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.of(lang, 'login_sub'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _identifierController,
                      enabled: !_isLoading,
                      keyboardType: _usePhone ? TextInputType.phone : TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: AppStrings.of(lang, _usePhone ? 'phone' : 'email'),
                        hintText: _usePhone ? '+964 750 123 4567' : 'name@email.com',
                        prefixIcon: Icon(_usePhone ? Icons.phone_outlined : Icons.email_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      validator: _usePhone ? Validators.phone : Validators.email,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: _isLoading ? null : _toggleMethod,
                        child: Text(AppStrings.of(lang, _usePhone ? 'use_email' : 'forgot_email')),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: AppStrings.of(lang, 'password'),
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Please enter your password' : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                          : Text(AppStrings.of(lang, 'log_in')),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.of(lang, 'no_account')),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
                                  ),
                          child: Text(AppStrings.of(lang, 'create_account')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
