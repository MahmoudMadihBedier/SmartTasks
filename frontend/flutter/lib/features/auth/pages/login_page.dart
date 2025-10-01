import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';

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
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AsyncValue>((authViewModelProvider), (previous, next) {
      if (next is AsyncData) {
        if (next.value != null) {
          Navigator.pushReplacementNamed(context, '/projects');
        }
      } else if (next is AsyncError) {
        final error = next.error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${error.toString()}')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('SmartTasks - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
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
              child: _loading ? const CircularProgressIndicator() : const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // TODO: route to register page
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