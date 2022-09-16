import 'dart:convert';

import 'package:finalize_prayer_app/constant/widgets/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  Future<void> getPrayerTime(BuildContext? context) async {
    // JsonStore jsonStore = JsonStore();
    // await jsonStore.setItem('timings', res.body);
    print('in get Prayer Time function');
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.reload();
      double? longitude = prefs.getDouble('longitude');
      double? latitude = prefs.getDouble('latitude');
      print('$longitude $latitude');
      http.Response res = await http.get(
        Uri.parse(
          // 'https://api.aladhan.com/v1/calendar?latitude=24.8607&longitude=67.0011&method=2&month=11&year=2022',
          'https://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&method=2&month=11&year=2022',
        ),
      );
      prefs.reload();
      await prefs.setString(
        'timings',
        jsonEncode(res.body),
      );
      print('in try ---> ${res.body}');
    } catch (e) {
      print('in catch $e');
      // showSnackBar(context, e.toString());
    }
  }
}
