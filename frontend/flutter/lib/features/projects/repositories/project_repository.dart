import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../models/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> fetchProjects({int page = 1, int pageSize = 20});
}

class ProjectRepositoryImpl implements ProjectRepository {
  final ApiClient apiClient;

  ProjectRepositoryImpl({required this.apiClient});
    
  @override
  Future<List<Project>> fetchProjects({int page = 1, int pageSize = 20}) async {
    final resp = await apiClient.get('/projects/',
        queryParameters: {'page': page, 'page_size': pageSize});
    final data = resp.data as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ??
        data['projects'] as List<dynamic>? ??
        [];
    return results
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
