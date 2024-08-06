// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalendarDataModel {
  DateTime get date => throw _privateConstructorUsedError;
  Color? get color => throw _privateConstructorUsedError;
  bool get showDot => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarDataModelCopyWith<CalendarDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarDataModelCopyWith<$Res> {
  factory $CalendarDataModelCopyWith(
          CalendarDataModel value, $Res Function(CalendarDataModel) then) =
      _$CalendarDataModelCopyWithImpl<$Res, CalendarDataModel>;
  @useResult
  $Res call({DateTime date, Color? color, bool showDot, String text});
}

/// @nodoc
class _$CalendarDataModelCopyWithImpl<$Res, $Val extends CalendarDataModel>
    implements $CalendarDataModelCopyWith<$Res> {
  _$CalendarDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? color = freezed,
    Object? showDot = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color?,
      showDot: null == showDot
          ? _value.showDot
          : showDot // ignore: cast_nullable_to_non_nullable
              as bool,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarDataModelImplCopyWith<$Res>
    implements $CalendarDataModelCopyWith<$Res> {
  factory _$$CalendarDataModelImplCopyWith(_$CalendarDataModelImpl value,
          $Res Function(_$CalendarDataModelImpl) then) =
      __$$CalendarDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, Color? color, bool showDot, String text});
}

/// @nodoc
class __$$CalendarDataModelImplCopyWithImpl<$Res>
    extends _$CalendarDataModelCopyWithImpl<$Res, _$CalendarDataModelImpl>
    implements _$$CalendarDataModelImplCopyWith<$Res> {
  __$$CalendarDataModelImplCopyWithImpl(_$CalendarDataModelImpl _value,
      $Res Function(_$CalendarDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? color = freezed,
    Object? showDot = null,
    Object? text = null,
  }) {
    return _then(_$CalendarDataModelImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color?,
      showDot: null == showDot
          ? _value.showDot
          : showDot // ignore: cast_nullable_to_non_nullable
              as bool,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CalendarDataModelImpl implements _CalendarDataModel {
  const _$CalendarDataModelImpl(
      {required this.date,
      required this.color,
      required this.showDot,
      required this.text});

  @override
  final DateTime date;
  @override
  final Color? color;
  @override
  final bool showDot;
  @override
  final String text;

  @override
  String toString() {
    return 'CalendarDataModel(date: $date, color: $color, showDot: $showDot, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarDataModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.showDot, showDot) || other.showDot == showDot) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, color, showDot, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarDataModelImplCopyWith<_$CalendarDataModelImpl> get copyWith =>
      __$$CalendarDataModelImplCopyWithImpl<_$CalendarDataModelImpl>(
          this, _$identity);
}

abstract class _CalendarDataModel implements CalendarDataModel {
  const factory _CalendarDataModel(
      {required final DateTime date,
      required final Color? color,
      required final bool showDot,
      required final String text}) = _$CalendarDataModelImpl;

  @override
  DateTime get date;
  @override
  Color? get color;
  @override
  bool get showDot;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$CalendarDataModelImplCopyWith<_$CalendarDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
