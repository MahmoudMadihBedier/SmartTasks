import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di.dart';

import '../../models/project.dart';

final projectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  final repo = ref.read(projectRepositoryProvider);
  return repo.fetchProjects();
});

class ProjectListPage extends ConsumerWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProjects = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: asyncProjects.when(
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(child: Text('No projects yet'));
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, i) {
              final p = projects[i];
              return ListTile(
                title: Text(p.title),
                subtitle: Text(p.description),
                onTap: () {
                  // TODO: open project details
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load projects: $e')),
      ),
    );
  }
}