import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigureTime extends StatefulWidget {
  final String clockNo;
  const ConfigureTime({
    Key? key,
    required this.clockNo,
  }) : super(key: key);

  @override
  State<ConfigureTime> createState() => _ConfigureTimeState();
}

class _ConfigureTimeState extends State<ConfigureTime> {
  TimeOfDay? time = const TimeOfDay(hour: 12, minute: 12);
  TimeOfDay? silentTime;
  TimeOfDay? ringingTime;

  @override
  void initState() {
    super.initState();
    setClockTime();
  }

  void setClockTime() async {
    final prefs = await SharedPreferences.getInstance();
    int? silentHour = prefs.getInt('${widget.clockNo}_silent_hour');
    int? silentMins = prefs.getInt('${widget.clockNo}_silent_mins');
    int? ringingHour = prefs.getInt('${widget.clockNo}_ringing_hour');
    int? ringingMins = prefs.getInt('${widget.clockNo}_ringing_mins');

    if (silentHour != null &&
        silentMins != null &&
        ringingHour != null &&
        ringingMins != null) {
      silentTime = TimeOfDay(hour: silentHour, minute: silentMins);
      ringingTime = TimeOfDay(hour: ringingHour, minute: ringingMins);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: silentTime ?? time!,
                  );
                  if (newTime != null) {
                    setState(() {
                      silentTime = newTime;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('${widget.clockNo}_silent_hour',
                        silentTime!.hour.toInt());
                    await prefs.setInt('${widget.clockNo}_silent_mins',
                        silentTime!.minute.toInt());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    silentTime == null
                        ? '${time!.hour.toString()} : ${time!.minute.toString()}'
                        : '${silentTime!.hour.toString()} : ${silentTime!.minute.toString()}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Text('Silent Time'),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: ringingTime ?? time!,
                  );
                  if (newTime != null) {
                    setState(() {
                      ringingTime = newTime;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('${widget.clockNo}_ringing_hour',
                        ringingTime!.hour.toInt());
                    await prefs.setInt('${widget.clockNo}_ringing_mins',
                        ringingTime!.minute.toInt());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    ringingTime == null
                        ? '${time!.hour.toString()} : ${time!.minute.toString()}'
                        : '${ringingTime!.hour.toString()} : ${ringingTime!.minute.toString()}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Text('Ringing Time'),
            ],
          ),
        ],
      ),
    );
  }
}
