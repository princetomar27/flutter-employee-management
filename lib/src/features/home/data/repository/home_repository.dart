import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../datasource/home_datasource.dart';
import '../entities/check_in_entity.dart';
import '../entities/check_in_params.dart';
import '../entities/check_out_entity.dart';
import '../entities/check_out_params.dart';
import '../entities/location_entity.dart';
import '../entities/location_track_entity_params.dart';

abstract class HomeRepository {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();

  Future<Either<Failure, CheckInEntity>> checkInUser(CheckInParams params);

  Future<Either<Failure, CheckOutEntity>> checkOutUser(CheckOutParams params);

  Future<Either<Failure, LocationTrackEntity>> trackUserLocation(
      LocationTrackParams params);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource homeDatasource;

  HomeRepositoryImpl({required this.homeDatasource});

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    return homeDatasource.getCurrentLocation();
  }

  @override
  Future<Either<Failure, CheckInEntity>> checkInUser(CheckInParams params) {
    return homeDatasource.checkInUser(params);
  }

  @override
  Future<Either<Failure, CheckOutEntity>> checkOutUser(CheckOutParams params) {
    return homeDatasource.checkOutUser(params);
  }

  @override
  Future<Either<Failure, LocationTrackEntity>> trackUserLocation(
      LocationTrackParams params) {
    return homeDatasource.trackUserLocation(params);
  }
}
