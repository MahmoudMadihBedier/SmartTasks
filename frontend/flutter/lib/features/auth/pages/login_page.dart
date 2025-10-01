import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../../models/user.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AsyncValue<User?>>(authViewModelProvider, (previous, next) {
      // navigate to projects when login produces a non-null user
      if (next is AsyncData<User?> && next.value != null) {
        Navigator.pushReplacementNamed(context, '/projects');
      } else if (next is AsyncError) {
        final err = next.error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${err.toString()}')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('SmartTasks - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('email_field'),
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              key: const Key('password_field'),
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      await ref.read(authViewModelProvider.notifier).login(_emailCtrl.text.trim(), _passCtrl.text.trim());
                      setState(() => _loading = false);
                    },
              child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // TODO: push register page when implemented
              },
              child: const Text('Register'),
            ),
            if (authState is AsyncLoading) const Padding(padding: EdgeInsets.only(top: 12), child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}