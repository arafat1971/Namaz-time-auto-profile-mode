import 'package:cron/cron.dart';
import 'package:finalize_prayer_app/services/profile_mode_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoModeServices {
  void setProfileMode() async {
    final ProfileModeServices profileModeServices = ProfileModeServices();
    final cron = Cron();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    String? profileStatus = prefs.getString('profile_status');

    final List count = ['first', 'second', 'third', 'fourth', 'fifth'];
    for (int i = 0; i < count.length; i++) {
      int? silentHour = prefs.getInt('${count[i]}_silent_hour');
      int? silentMins = prefs.getInt('${count[i]}_silent_mins');
      int? ringingHour = prefs.getInt('${count[i]}_ringing_hour');
      int? ringingMins = prefs.getInt('${count[i]}_ringing_mins');

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

      // To activate silent mode
      if (silentHour != null && silentMins != null) {
        cron.schedule(Schedule.parse('$silentMins $silentHour * * *'),
            () async {
          profileModeServices.setVibrateMode();
          print('Silent ----> $silentHour $silentMins');
        });
      }

      //To activate ringing mode
      if (ringingHour != null && ringingMins != null) {
        cron.schedule(Schedule.parse('$ringingMins $ringingHour * * *'),
            () async {
          profileModeServices.setNormalMode();
          print('Ringing ----> $ringingHour $ringingMins');
        });
      }
    }
  }
}
