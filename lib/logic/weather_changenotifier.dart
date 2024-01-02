import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/logic/weather_http.dart';
import 'package:weather_app/model/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  Weather client = Weather();
  WeatherModel? data;

  Future<Position> _getCurrentLocation() async {
    bool servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      if (kDebugMode) {
        print('Location service is disabled');
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromCoordinates(Position location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placemarks[0];

      String currentAddress =
          "${place.locality ?? 'Kyiv'}, ${place.country ?? 'Ukraine'}";

      if (kDebugMode) {
        print(currentAddress);
      } // You can do something with the address if needed

      notifyListeners(); // Notify listeners after updating the address
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> getDataFromLocation() async {
    try {
      Position position = await _getCurrentLocation();

      double latitude = position.latitude;
      double longitude = position.longitude;

      await getAddressFromCoordinates(position);

      String cityName = await getCityName(latitude, longitude);
      await getData(cityName, latitude: latitude, longitude: longitude);

      notifyListeners();
    } catch (e) {
      print("Error getting location or weather data: $e");
    }
  }

  Future<void> getData(String cityName,
      {required double latitude, required double longitude}) async {
    try {
      WeatherModel? weatherData = await client.getWeather(cityName,
          latitude: latitude, longitude: longitude);

      if (weatherData != null) {
        data = weatherData;
      } else {
        // Handle the case where weather data is null
        if (kDebugMode) {
          print("Weather data is null");
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error getting weather data: $e");
      }
    }
  }
}

Future<String> getCityName(double latitude, double longitude) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

  // Extract city name  from the first placemark
  if (placemarks.isNotEmpty) {
    String locality = placemarks[0].locality ?? 'Kyiv';
    return locality;
  } else {
    return 'Kyiv';
  }
}
