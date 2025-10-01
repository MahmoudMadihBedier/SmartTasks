import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network/api_client.dart';
import 'storage/secure_storage.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/projects/repositories/project_repository.dart';

// Application-level providers wiring abstractions to implementations.

final appInitProvider = Provider<void Function()>((ref) {
  return () {
    // any async initialization (DB, Firebase) can be triggered here if needed
  };
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.read(secureStorageProvider);
  return ApiClient(secureStorage: storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return AuthRepositoryImpl(
      apiClient: client, secureStorage: ref.read(secureStorageProvider));
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return ProjectRepositoryImpl(apiClient: client);
});
