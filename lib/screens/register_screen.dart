import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/exceptions.dart';
import '../core/validators.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _isLoading = true);
    try {
      await auth.register(name: _nameController.text, phone: _phoneController.text, password: _passwordController.text);
      navigator.popUntil((route) => route.isFirst);
    } on PhoneAlreadyRegisteredException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text('Could not create the account.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().language;
    final nameLabel = lang == AppLanguage.kurdish ? '\u0646\u0627\u0648\u06CC \u062A\u06D5\u0648\u0627\u0648' : lang == AppLanguage.arabic ? '\u0627\u0644\u0627\u0633\u0645 \u0627\u0644\u0643\u0627\u0645\u0644' : 'Full name';
    final confirmLabel = lang == AppLanguage.kurdish ? '\u062F\u06B5\u0646\u06CC\u0627\u06A9\u0631\u062F\u0646\u06D5\u0648\u06D5\u06CC \u0648\u0634\u06D5\u06CC \u062A\u06CE\u067E\u06D5\u0695' : lang == AppLanguage.arabic ? '\u062A\u0623\u0643\u064A\u062F \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631' : 'Confirm password';

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(lang, 'create_account'))),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    enabled: !_isLoading,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: nameLabel, prefixIcon: const Icon(Icons.person_outline), border: const OutlineInputBorder()),
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: AppStrings.of(lang, 'phone'), hintText: '+964 750 123 4567', prefixIcon: const Icon(Icons.phone_outlined), border: const OutlineInputBorder()),
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: AppStrings.of(lang, 'password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => setState(() => _obscure = !_obscure)),
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmController,
                    enabled: !_isLoading,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(labelText: confirmLabel, prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder()),
                    validator: Validators.confirmPassword(() => _passwordController.text),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(AppStrings.of(lang, 'create_account')),
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
