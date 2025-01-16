import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../datasource/home_datasource.dart';
import '../entities/location_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource homeDatasource;

  HomeRepositoryImpl({required this.homeDatasource});

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    return homeDatasource.getCurrentLocation();
  }
}
