import 'package:finalize_prayer_app/services/api_services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationServices {
  Future<void> getLocation() async {
    print('In get location');
    final prefs = await SharedPreferences.getInstance();
    List<String>? location_data = [];
    location_data = prefs.getStringList('locationData');
    Location location = Location();
    if (location_data == null || location_data.isEmpty) {
      print('in if');
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      print('check');

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      print('after permission');

      locationData = await location.getLocation();
      await prefs.setStringList('locationData',
          [locationData.latitude.toString(), locationData.latitude.toString()]);
      double longitude = locationData.longitude ?? 0;
      double latitude = locationData.latitude ?? 0;

      await prefs.setDouble('longitude', longitude);
      await prefs.setDouble('latitude', latitude);

      final ApiServices apiServices = ApiServices();
      apiServices.getPrayerTime(null);
    }

    location.onLocationChanged.listen((LocationData currentLocation) async {
      // Use current location
      await prefs.setStringList('locationData', [
        currentLocation.latitude.toString(),
        currentLocation.longitude.toString()
      ]);
      double longitude = currentLocation.longitude ?? 0;
      double latitude = currentLocation.latitude ?? 0;

      await prefs.setDouble('longitude', longitude);
      await prefs.setDouble('latitude', latitude);
    });
  }
}
