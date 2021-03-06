# simple_time_range_picker

A simple_time_range_picker is simple time range widget.

## Overview

<img src="https://user-images.githubusercontent.com/885696/93012152-d136ec00-f5d8-11ea-8d74-32400b18a564.gif" width="50%">

## Getting Started

### Usage

- `TimeRangePicker.show` on call at `onPressed` ,`onTap` etc.

```dart
RaisedButton(
    child: Text("OpenPicker"),
    onPressed: () => TimeRangePicker.show(
        context: context,
    ),
);
```

- Use `onSubmitted` to get the submit time

```dart
RaisedButton(
    child: Text("OpenPicker"),
    onPressed: () => TimeRangePicker.show(
        context: context,
        onSubmitted: (TimeRangeValue value) {
            print("${value.startTime} - ${value.endTime}");
        },
    ),
);
```

### API

| name                    | default                   | note                                           |
| ----------------------- | ------------------------- | ---------------------------------------------- |
| okLabel                 | `OK`                      | set a label at `ok` button                       |
| cancelLabel             | `CANCEL`                  | set a label at `cancel` button                   |
| startTime               |                           | set a `start` time                               |
| endTime                 |                           | set a `end` time                                 |
| headerDefaultStartLabel | `START`                   | set a label `start` time on header when empty    |
| headerDefaultEndLabel   | `END`                     | set a label `end` time on header when empty      |
| autoAdjust              | `true`                    | adjust if the `start` time is after the `end` time |
| unSelectedEmpty         | `true`                    | returns null when not selected |
| timeRangeViewType       | `TimeRangeViewType.start` | first view at `start` or `end` time                 |
| onStartTimeChange       |                           | callback for changed `start` time                |
| onEndTimeChange         |                           | callback for changed `end` time                  |
| onSubmitted             |                           | callback for submitted                         |
| onCancel                |                           | callback for canceled                          |
