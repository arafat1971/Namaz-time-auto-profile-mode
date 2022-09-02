import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
// import 'package:json_store/json_store.dart';

class NamazTimeScreen extends StatefulWidget {
  const NamazTimeScreen({Key? key}) : super(key: key);

  @override
  State<NamazTimeScreen> createState() => _NamazTimeScreenState();
}

class _NamazTimeScreenState extends State<NamazTimeScreen> {
  Map<String, dynamic>? jsonData = null;
  double? latitude;
  double? longitude;
  List<String>? locationData = [];
  @override
  void initState() {
    super.initState();
    // getRenderedData();
    locationVariables();
  }

  locationVariables() async {
    final prefs = await SharedPreferences.getInstance();
    latitude = prefs.getDouble('latitude');
    longitude = prefs.getDouble('longitude');
    setState(() {});
  }

  DateTime now = DateTime.now();
  // void getRenderedData() async {
  //   JsonStore jsonStore = JsonStore();
  //   DateTime dateMont = DateTime(now.year, now.month + 1, 0);
  //   DateFormat formatter = DateFormat('MMM');
  //   String monthAbbr = formatter.format(dateMont);

  //   jsonData = await jsonStore.getItem(monthAbbr);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Timings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Longitude: $longitude, Latitude: $latitude'),
            namazTimes('Fajr', '04:53 (PKT)'),
            namazTimes('Sunrise', '06:01 (PKT)'),
            namazTimes('Dhuhr', '12:38 (PKT)'),
            namazTimes('Asr', '16:05 (PKT)'),
            namazTimes('Sunset', '19:14 (PKT)'),
            namazTimes('Maghrib', '19:14 (PKT)'),
            namazTimes('Isha', '20:22 (PKT)'),
          ],
        ),
      ),
    );
  }
}

Container namazTimes(String name, String time) {
  return Container(
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              '$name :',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '$time ',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
      ],
    ),
  );
}
