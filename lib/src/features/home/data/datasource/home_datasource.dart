import 'package:dartz/dartz.dart';
import 'package:flutteremployeemanagement/src/core/storage/storage_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/failures.dart';
import '../entities/location_entity.dart';

abstract class HomeDatasource {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
}

class HomeDatasourceImpl implements HomeDatasource {
  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(
              PermissionFailure(message: 'Location permission denied'));
        }
      }

      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = placemarks.isNotEmpty
          ? '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}'
          : 'Address not available';

      final location = LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      await StorageHelper.saveUserLocationDataToLocal(location);

      return Right(location);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch location: $e'));
    }
  }
}
