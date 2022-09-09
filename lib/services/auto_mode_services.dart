import 'dart:async';

import 'package:cron/cron.dart';
import 'package:finalize_prayer_app/services/local_notification_services.dart';
import 'package:finalize_prayer_app/services/profile_mode_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoModeServices {
  void setProfileMode() async {
    //-------------------- Initializing services and libraries -------------
    final ProfileModeServices profileModeServices = ProfileModeServices();
    final LocalNotificationServices localNotificationServices =
        LocalNotificationServices();
    localNotificationServices.intiate();

    final cron = Cron();
    //-------------------- Initializing services and libraries -------------

    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final List count = ['first', 'second', 'third', 'fourth', 'fifth'];
    for (int i = 0; i < count.length; i++) {
      int? silentHour = prefs.getInt('${count[i]}_silent_hour');
      int? silentMins = prefs.getInt('${count[i]}_silent_mins');
      int? ringingHour = prefs.getInt('${count[i]}_ringing_hour');
      int? ringingMins = prefs.getInt('${count[i]}_ringing_mins');

      if (silentHour != null &&
          silentMins != null &&
          ringingHour != null &&
          ringingMins != null) {
        print('$silentHour:$silentMins - $ringingHour:$ringingMins');

        String sil = '$silentHour:$silentMins';
        String rin = '$ringingHour:$ringingMins';

        if (sil != rin) {
          debugPrint('in If on $i');

          // To activate silent mode
          cron.schedule(Schedule.parse('$silentMins $silentHour * * *'),
              () async {
            //to ring the customize sound
            FlutterRingtonePlayer.play(fromAsset: "assets/water_drop.mp3");
            Future.delayed(const Duration(seconds: 3), () async {
              localNotificationServices.showNotification(
                  id: 0, title: 'Namaz Time', body: 'Silent mode activated');
              FlutterRingtonePlayer.stop();
              profileModeServices.setVibrateMode();
            });

            debugPrint('Silent ----> $silentHour $silentMins');
          });

          //To activate ringing mode
          cron.schedule(Schedule.parse('$ringingMins $ringingHour * * *'),
              () async {
            profileModeServices.setNormalMode();
            debugPrint('Ringing ----> $ringingHour $ringingMins');
          });
        }
      }
    }
  }
}

// ------------------- Previous logic -------------
    // String? profileStatus = prefs.getString('profile_status');

      // if (silentMins != null &&
      //     silentHour != null &&
      //     ringingHour != null &&
      //     ringingMins != null) {
      //   // DateTime now = DateTime.now();
      // DateTime silentTime =
      //     DateTime(now.year, now.month, now.day, silentHour, silentMins);
      // DateTime ringingTime =
      //     DateTime(now.year, now.month, now.day, ringingHour, ringingMins);

      // if (now.isAfter(silentTime) && now.isBefore(ringingTime)) {
      //   if (profileStatus == 'ringing' || profileStatus == null) {
      //     profileModeServices.setVibrateMode();
      //     await prefs.setString('profile_status', 'vibrate');
      //   }
      // }
      // }
// ------------------- Previous logic -------------
