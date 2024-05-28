import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_data_model.freezed.dart';

@freezed
abstract class CalendarDataModel with _$CalendarDataModel {
  const factory CalendarDataModel({
    required DateTime date,
    required Color? color,
    required String? text,
  }) = _CalendarDataModel;
}
