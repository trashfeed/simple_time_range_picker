import 'package:flutter/material.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? SizedBox.shrink()),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Sampe"),
            ),
            body: Container(
              padding: EdgeInsets.all(50),
              alignment: Alignment.center,
              child: Column(
                children: [
                  //
                  // Example start
                  // -------------
                  //
                  ElevatedButton(
                    child: Text("OpenPicker"),
                    onPressed: () => TimeRangePicker.show(
                      context: context,
                      unSelectedEmpty: true,
                      startTime: TimeOfDay(
                          hour: _startTime.hour, minute: _startTime.minute),
                      endTime: TimeOfDay(
                          hour: _endTime.hour, minute: _endTime.minute),
                      onSubmitted: (TimeRangeValue value) {
                        if (value.startTime != null && value.endTime != null) {
                          setState(() {
                            _startTime = value.startTime!;
                            _endTime = value.endTime!;
                          });
                        }
                      },
                    ),
                  ),
                  Text(
                    "start: ${_timeFormatted(_startTime)}",
                  ),
                  Text(
                    "end: ${_timeFormatted(_endTime)}",
                  ),
                  //
                  // -------------
                  // Example end
                  //
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _timeFormatted(TimeOfDay? time) {
    if (time == null) return "--:--";
    return "${time.hour}:${time.minute}";
  }
}
