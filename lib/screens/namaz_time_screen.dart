import 'dart:convert';

import 'package:finalize_prayer_app/services/api_services.dart';
import 'package:finalize_prayer_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
// import 'package:json_store/json_store.dart';

class NamazTimeScreen extends StatefulWidget {
  const NamazTimeScreen({Key? key}) : super(key: key);

  @override
  State<NamazTimeScreen> createState() => _NamazTimeScreenState();
}

class _NamazTimeScreenState extends State<NamazTimeScreen> {
  late final LocationServices locationServices;
  final ApiServices apiServices = ApiServices();
  // Map<String, dynamic>? jsonData = null;
  var jsonData;
  double? latitude;
  double? longitude;
  List<String>? locationData = [];
  PermissionStatus? permissionGranted;
  late final prefs;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // getRenderedData();
    isLoading = true;
    initPref();
    // locationVariables();
    locationServices = LocationServices();
  }

  initPref() async {
    prefs = await SharedPreferences.getInstance();
    locationVariables();
  }

  reloadFunction() async {
    // setState(() {
    //   isLoading = true;
    // });
    await apiServices.getPrayerTime(context);
    var encodedData;
    await prefs.reload();

    setState(() {
      encodedData = prefs.getString('timings') ??
          jsonEncode('Check your internet connection and try again');
    });
    print('pref initialize -- > $encodedData');

    setState(() {
      jsonData = jsonDecode(encodedData);
      // isLoading = false;
    });
  }

  void locationVariables() async {
    prefs.reload();
    latitude = prefs.getDouble('latitude');
    longitude = prefs.getDouble('longitude');
    var encodedData = prefs.getString('timings');
    //  ??
    //     jsonEncode({'Check your internet connection and try again': 'code'});
    if (encodedData != null) {
      setState(() {
        jsonData = jsonDecode(encodedData);
      });
    } else {
      Future.delayed(const Duration(seconds: 5), () {
        var encodedData = prefs.getString('timings');
        if (encodedData != null) {
          setState(() {
            jsonData = jsonDecode(encodedData);
          });
        }
      });
    }
    print('json data ---> $jsonData');

    setState(() {
      isLoading = false;
    });
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
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : jsonData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Need your location access to get data accordingly'),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          Location location = Location();
                          // await location.requestService();
                          permissionGranted = await location.hasPermission();
                          if (permissionGranted == PermissionStatus.granted) {
                            if (jsonData == null) {
                              // setState(() {
                              //   isLoading = true;
                              // });
                              await apiServices.getPrayerTime(context);
                              Future.delayed(const Duration(seconds: 5), () {
                                locationVariables();
                              });
                            }
                          } else {
                            await locationServices.getLocation();
                            //Repeating upper logic
                            permissionGranted = await location.hasPermission();
                            if (permissionGranted == PermissionStatus.granted) {
                              if (jsonData == null) {
                                // setState(() {
                                //   isLoading = true;
                                // });
                                await apiServices.getPrayerTime(context);
                                Future.delayed(const Duration(seconds: 5), () {
                                  locationVariables();
                                });
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            //Repeating upper logic
                          }
                          print('location button pressed');
                        },
                        child: const Text(
                          'Get Location',
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Longitude: $longitude, Latitude: $latitude'),
                      // Text(jsonDecode(jsonData)['data'][0]['timings'].toString()),
                      namazTimes(
                          'Fajr',
                          jsonDecode(jsonData)['data'][0]['timings']['Fajr']
                              .toString()),
                      namazTimes(
                          'Sunrise',
                          jsonDecode(jsonData)['data'][0]['timings']['Sunrise']
                              .toString()),
                      namazTimes(
                          'Dhuhr',
                          jsonDecode(jsonData)['data'][0]['timings']['Dhuhr']
                              .toString()),
                      namazTimes(
                          'Asr',
                          jsonDecode(jsonData)['data'][0]['timings']['Asr']
                              .toString()),
                      namazTimes(
                          'Sunset',
                          jsonDecode(jsonData)['data'][0]['timings']['Sunset']
                              .toString()),
                      namazTimes(
                          'Maghrib',
                          jsonDecode(jsonData)['data'][0]['timings']['Maghrib']
                              .toString()),
                      namazTimes(
                          'Isha',
                          jsonDecode(jsonData)['data'][0]['timings']['Isha']
                              .toString()),
                    ],
                  ),
                ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: reloadFunction,
      //   tooltip: 'Reload',
      //   child: const Icon(Icons.replay_outlined),
      // ),
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
