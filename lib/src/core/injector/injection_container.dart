import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/attendace/data/datasource/attendance_datasource.dart';
import '../../features/attendace/data/repository/attendance_repository.dart';
import '../../features/authentication/data/datasource/authentication_datasource.dart';
import '../../features/authentication/data/repository/authentication_repository.dart';
import '../../features/home/data/datasource/home_datasource.dart';
import '../../features/home/data/repository/home_repository.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<ApiClient>(
      () => ApiClient(client: sl<http.Client>()));

  // Data Sources
  sl.registerLazySingleton<AuthenticationDatasource>(
      () => AuthenticationDatasourceImpl(apiClient: sl<ApiClient>()));

  sl.registerLazySingleton<HomeDatasource>(
    () => HomeDatasourceImpl(
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton<AttendanceDatasource>(
    () => AttendanceDatasourceImpl(
      apiClient: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      datasource: sl<AuthenticationDatasource>(),
    ),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      homeDatasource: sl<HomeDatasource>(),
    ),
  );

  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      attendanceDatasource: sl<AttendanceDatasource>(),
    ),
  );
}
