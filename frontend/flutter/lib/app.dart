import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di.dart';
import 'features/auth/pages/login_page.dart';
import 'features/projects/pages/project_list_page.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'models/user.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // trigger any initialization hooks
    ref.read(appInitProvider)();

    return MaterialApp(
      title: 'SmartTasks',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (ctx) {
          final authState = ref.watch(authViewModelProvider);
          // if user already logged in, go to projects; otherwise show login
          return authState.when(
            data: (user) => (user != null) ? const ProjectListPage() : const LoginPage(),
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (_, __) => const LoginPage(),
          );
        },
        '/projects': (_) => const ProjectListPage(),
      },
    );
  }
}