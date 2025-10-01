import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/pages/login_page.dart';
import 'features/projects/pages/project_list_page.dart';
import 'core/di.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize DI providers if needed
    ref.read(appInitProvider)();
    return MaterialApp(
      title: 'SmartTasks',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: {
        '/': (_) => const LoginPage(),
        '/projects': (_) => const ProjectListPage(),
      },
    );
  }
}