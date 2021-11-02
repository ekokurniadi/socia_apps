import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './settings.dart';
import './helper.dart';
import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

final Helper helper = Helper();

class Functional {
 

  void sendLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("id");
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);

    // mendapatkan alamat
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var alamat = addresses.first;

    // print(alamat.addressLine.toString());
    final response = await http.post(Settings.BASE_URL + "sendLocation", body: {
      "id": userId,
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "afc": alamat.addressLine.toString(),
    });
    final res = jsonDecode(response.body);
    // print(res);
    if (res['status'] == 200) {
      // print("Lokasi Petugas saat ini : $position");
    } else {
      // print("Gagal mendapatkan lokasi");
    }
  }
}
