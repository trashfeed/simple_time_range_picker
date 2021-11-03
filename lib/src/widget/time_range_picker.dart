import 'package:flutter/material.dart';
import 'package:simple_time_range_picker/src/widget/time_single_picker.dart';

enum TimeRangeViewType { start, end }

class TimeRangeValue {
  TimeRangeValue.value({this.startTime, this.endTime});
  TimeOfDay? startTime;
  TimeOfDay? endTime;
}

class TimeRangePicker {
  TimeRangePicker.show({
    required BuildContext context,
    String? okLabel,
    String? cancelLabel,
    String? headerDefaultStartLabel,
    String? headerDefaultEndLabel,
    bool? autoAdjust,
    bool? unSelectedEmpty,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TimeRangeViewType? timeRangeViewType,
    ValueChanged<TimeOfDay>? onStartTimeChange,
    ValueChanged<TimeOfDay>? onEndTimeChange,
    required ValueChanged<TimeRangeValue> onSubmitted,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return _TimeRangeDialog(
            okLabel: okLabel ?? 'OK',
            cancelLabel: cancelLabel ?? 'CANCEL',
            unSelectedEmpty: unSelectedEmpty ?? false,
            headerDefaultStartLabel: headerDefaultStartLabel ?? 'START',
            headerDefaultEndLabel: headerDefaultEndLabel ?? 'END',
            autoAdjust: autoAdjust ?? true,
            timeRangeViewType: timeRangeViewType ?? TimeRangeViewType.start,
            onStartTimeChange: onStartTimeChange,
            onEndTimeChange: onEndTimeChange,
            startTime: startTime,
            endTime: endTime,
            onSubmitted: onSubmitted,
            onCancel: onCancel);
      },
    );
  }
}

class _TimeRangeDialog extends StatefulWidget {
  final String okLabel;
  final String cancelLabel;
  final String headerDefaultStartLabel;
  final String headerDefaultEndLabel;
  final ValueChanged<TimeOfDay>? onStartTimeChange;
  final ValueChanged<TimeOfDay>? onEndTimeChange;
  final bool autoAdjust;
  final bool unSelectedEmpty;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final TimeRangeViewType timeRangeViewType;
  final ValueChanged<TimeRangeValue>? onSubmitted;
  final VoidCallback? onCancel;

  _TimeRangeDialog(
      {required this.okLabel,
      required this.cancelLabel,
      this.startTime,
      this.endTime,
      required this.headerDefaultStartLabel,
      required this.headerDefaultEndLabel,
      this.timeRangeViewType = TimeRangeViewType.start,
      required this.autoAdjust,
      required this.unSelectedEmpty,
      this.onStartTimeChange,
      this.onEndTimeChange,
      this.onSubmitted,
      this.onCancel});

  @override
  State createState() {
    return _TimeRangeDialogState();
  }
}

class _TimeRangeDialogState extends State<_TimeRangeDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TimeOfDay? _startDefaultTime;
  TimeOfDay? _endDefaultTime;
  Orientation? _orientation;
  final double _kTimePickerWidthPortrait = 328.0;
  final double _kTimePickerWidthLandscape = 528.0;
  final double _kTimePickerHeightPortrait = 434.0;
  final double _kTimePickerHeightLandscape = 316.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: 2,
        initialIndex:
            widget.timeRangeViewType == TimeRangeViewType.start ? 0 : 1);
    _startTime = widget.startTime ?? null;
    _endTime = widget.endTime ?? null;
    _startDefaultTime =
        _startTime ?? (widget.unSelectedEmpty ? null : TimeOfDay.now());
    _endDefaultTime =
        _endTime ?? (widget.unSelectedEmpty ? null : TimeOfDay.now());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _orientation = MediaQuery.of(context).orientation;
    return AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Container(
          width: _orientation == Orientation.portrait
              ? _kTimePickerWidthPortrait
              : _kTimePickerWidthLandscape,
          height: _orientation == Orientation.portrait
              ? _kTimePickerHeightPortrait
              : _kTimePickerHeightLandscape,
          child: Scaffold(
            appBar: TabBar(
                labelColor: Theme.of(context).textTheme.bodyText1!.color,
                controller: _tabController,
                tabs: [
                  Tab(
                      text: _formatTime(_startTime) ??
                          widget.headerDefaultStartLabel),
                  Tab(
                      text: _formatTime(_endTime) ??
                          widget.headerDefaultEndLabel),
                ]),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [_startTimePicker(), _endTimePicker()],
            ),
          ),
        ));
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    final bool alwaysUse24HourFormat =
        MediaQuery.of(context).alwaysUse24HourFormat;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      time,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );
  }

  _updateTime({TimeOfDay? startTime, TimeOfDay? endTime}) {
    _autoAdjustTime(startTime: startTime, endTime: endTime);
    setState(() {
      if (startTime != null) _startTime = startTime;
      if (endTime != null) _endTime = endTime;
    });
  }

  _autoAdjustTime({TimeOfDay? startTime, TimeOfDay? endTime}) {
    if (!widget.autoAdjust) return;
    if (startTime != null) {
      _startTime = startTime;
      if (_timeToDouble(startTime) > _timeToDouble(_endTime)) {
        _endTime = _endTime?.replacing(hour: startTime.hour);
      }
    }
    if (endTime != null) {
      _endTime = endTime;
      if (_timeToDouble(_startTime) > _timeToDouble(endTime)) {
        _startTime = _startTime?.replacing(hour: endTime.hour);
      }
    }
    setState(() {
      _startTime = _startTime;
      _endTime = _endTime;
    });
  }

  double _timeToDouble(TimeOfDay? time) {
    if (time == null) return 0;
    return time.hour + time.minute / 60.0;
  }

  Widget _startTimePicker() {
    return _picker(_startTime, (value) {
      _updateTime(startTime: value);
      widget.onStartTimeChange?.call(value);
    });
  }

  Widget _endTimePicker() {
    return _picker(_endTime, (value) {
      _updateTime(endTime: value);
      widget.onEndTimeChange?.call(value);
    });
  }

  Widget _picker(TimeOfDay? initialTime, ValueChanged<TimeOfDay> onTimeChange) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TimeSinglePicker(
            initialTime: initialTime ?? TimeOfDay.now(),
            cancelText: widget.cancelLabel,
            confirmText: widget.okLabel,
            onTimeChange: onTimeChange,
            onSubmitted: (value) => widget.onSubmitted?.call(
                TimeRangeValue.value(
                    startTime: _startTime ?? _startDefaultTime,
                    endTime: _endTime ?? _endDefaultTime)),
            onCancel: widget.onCancel,
          )
        ],
      ),
    );
  }
}
