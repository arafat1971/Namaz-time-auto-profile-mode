import 'package:finalize_prayer_app/constant/widgets/configure_time.dart';
import 'package:finalize_prayer_app/constant/widgets/show_snack_bar.dart';
import 'package:finalize_prayer_app/services/profile_mode_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoModeScreen extends StatefulWidget {
  const AutoModeScreen({Key? key}) : super(key: key);

  @override
  State<AutoModeScreen> createState() => _AutoModeScreenState();
}

class _AutoModeScreenState extends State<AutoModeScreen> {
  final ProfileModeServices profileModeServices = ProfileModeServices();
  final List count = ['first', 'second', 'third', 'fourth', 'fifth'];
  String? _permissionStatus;

  Future<void> _getPermissionStatus() async {
    String? permission;
    permission = await profileModeServices.getPermissionStatus();
    setState(() {
      _permissionStatus = permission;
    });
    debugPrint(_permissionStatus);
  }

  @override
  void initState() {
    super.initState();
    _getPermissionStatus();
    // initializeVariabled();
  }

  void initializeVariabled() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.reload();
    for (int i = 0; i < count.length; i++) {
      int? silentHour = prefs.getInt('${count[i]}_silent_hour');
      int? silentMins = prefs.getInt('${count[i]}_silent_mins');
      int? ringingHour = prefs.getInt('${count[i]}_ringing_hour');
      int? ringingMins = prefs.getInt('${count[i]}_ringing_mins');
      if (silentHour == null) {
        await prefs.setInt('${count[i]}_silent_hour', 12);
      }
      if (silentMins == null) {
        await prefs.setInt('${count[i]}_silent_mins', 12);
      }
      if (ringingHour == null) {
        await prefs.setInt('${count[i]}_ringing_hour', 12);
      }
      if (ringingMins == null) {
        await prefs.setInt('${count[i]}_ringing_mins', 12);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set time for silent and ringing',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showSnackBar(context,
                'Set same time to deactivate auto silent and ringing mode'),
            icon: const Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _permissionStatus == null ||
              _permissionStatus == "Permissions not granted"
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Access require to change profile mode,'
                    '\n press "Grant Permission" to give access',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      // primary: const Color.fromARGB(255, 29, 201, 192),
                      side: const BorderSide(
                        // color: Color.fromARGB(255, 29, 201, 192),
                        color: Colors.blue,
                        width: 2,
                      ),
                      // shadowColor: const Color.fromARGB(255, 29, 201, 192),
                      backgroundColor: Colors.white,
                      elevation: 5,
                    ),
                    onPressed: () async {
                      await _getPermissionStatus();

                      if (_permissionStatus == "Permissions Enabled") {
                        setState(() {});
                      } else {
                        profileModeServices.openDoNotDisturbSettings();
                      }
                    },
                    child: const Text('Grant Permission'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ConfigureTime(clockNo: count[0]),
                    const SizedBox(height: 15.0),
                    ConfigureTime(clockNo: count[1]),
                    const SizedBox(height: 15.0),
                    ConfigureTime(clockNo: count[2]),
                    const SizedBox(height: 15.0),
                    ConfigureTime(clockNo: count[3]),
                    const SizedBox(height: 15.0),
                    ConfigureTime(clockNo: count[4]),
                  ],
                ),
              ),
            ),
    );
  }
}
