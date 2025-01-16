import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/data/entities/location_entity.dart';

class StorageHelper {
  static const String _userKey = 'loggedInUser';
  static const String _locationKey = 'userLocation';

  static Future<void> saveUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData);
    debugPrint("User data saved: $userData");
  }

  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<void> saveLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final time = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('lastLoginTime', time);
    debugPrint("Last login time saved: $time");
  }

  static Future<void> saveUserLocationDataToLocal(
      LocationEntity location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, location.toJson());
    debugPrint("User location data saved: ${location.toJson()}");
  }

  static Future<LocationEntity?> getUserLocationDataToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final locationData = prefs.getString(_locationKey);
    if (locationData != null) {
      return LocationEntity.fromJson(locationData);
    }
    return null;
  }
}
