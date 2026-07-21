import 'package:flutter/material.dart';

/// Alignment position for the NProgress bar.
enum NProgressPosition {
  /// Top of the parent or screen (default).
  top,

  /// Bottom of the parent or screen.
  bottom,
}

/// Configuration options for NProgress.
@immutable
class NProgressOptions {
  /// Minimum progress percentage on start (0.0 to 1.0). Default is 0.08.
  final double minimum;

  /// Animation curve for progress changes. Default is [Curves.ease].
  final Curve curve;

  /// Animation duration for progress value updates. Default is 200 milliseconds.
  final Duration speed;

  /// Whether to enable auto-incrementing trickling behavior. Default is true.
  final bool trickle;

  /// Time interval between trickle increments. Default is 200 milliseconds.
  final Duration trickleSpeed;

  /// Whether to display the spinning loader in the corner. Default is true.
  final bool showSpinner;

  /// Height of the progress bar in logical pixels. Default is 2.5.
  final double height;

  /// Primary color of the progress bar and spinner.
  /// Defaults to Color(0xFF2997FF) (NProgress signature blue).
  final Color color;

  /// Optional linear gradient for the progress bar.
  /// If provided, this overrides [color] for the bar (spinner still uses [color]).
  final Gradient? gradient;

  /// Position of the progress bar on screen (top or bottom). Default is [NProgressPosition.top].
  final NProgressPosition position;

  /// Position padding (e.g. safe area top inset offset).
  final EdgeInsets padding;

  /// Custom spinner alignment. Default is Alignment.topRight.
  final Alignment spinnerAlignment;

  /// Size of the spinner in logical pixels. Default is 18.0.
  final double spinnerSize;

  /// Whether to show the glowing head (peg shadow effect) at the end of the bar. Default is true.
  final bool showPeg;

  const NProgressOptions({
    this.minimum = 0.08,
    this.curve = Curves.ease,
    this.speed = const Duration(milliseconds: 200),
    this.trickle = true,
    this.trickleSpeed = const Duration(milliseconds: 200),
    this.showSpinner = true,
    this.height = 2.5,
    this.color = const Color(0xFF2997FF),
    this.gradient,
    this.position = NProgressPosition.top,
    this.padding = EdgeInsets.zero,
    this.spinnerAlignment = Alignment.topRight,
    this.spinnerSize = 18.0,
    this.showPeg = true,
  }) : assert(minimum >= 0.0 && minimum <= 1.0, 'minimum must be between 0.0 and 1.0');

  /// Creates a copy of this [NProgressOptions] with the given fields replaced.
  NProgressOptions copyWith({
    double? minimum,
    Curve? curve,
    Duration? speed,
    bool? trickle,
    Duration? trickleSpeed,
    bool? showSpinner,
    double? height,
    Color? color,
    Gradient? gradient,
    NProgressPosition? position,
    EdgeInsets? padding,
    Alignment? spinnerAlignment,
    double? spinnerSize,
    bool? showPeg,
  }) {
    return NProgressOptions(
      minimum: minimum ?? this.minimum,
      curve: curve ?? this.curve,
      speed: speed ?? this.speed,
      trickle: trickle ?? this.trickle,
      trickleSpeed: trickleSpeed ?? this.trickleSpeed,
      showSpinner: showSpinner ?? this.showSpinner,
      height: height ?? this.height,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      position: position ?? this.position,
      padding: padding ?? this.padding,
      spinnerAlignment: spinnerAlignment ?? this.spinnerAlignment,
      spinnerSize: spinnerSize ?? this.spinnerSize,
      showPeg: showPeg ?? this.showPeg,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NProgressOptions &&
        other.minimum == minimum &&
        other.curve == curve &&
        other.speed == speed &&
        other.trickle == trickle &&
        other.trickleSpeed == trickleSpeed &&
        other.showSpinner == showSpinner &&
        other.height == height &&
        other.color == color &&
        other.gradient == gradient &&
        other.position == position &&
        other.padding == padding &&
        other.spinnerAlignment == spinnerAlignment &&
        other.spinnerSize == spinnerSize &&
        other.showPeg == showPeg;
  }

  @override
  int get hashCode {
    return Object.hash(
      minimum,
      curve,
      speed,
      trickle,
      trickleSpeed,
      showSpinner,
      height,
      color,
      gradient,
      position,
      padding,
      spinnerAlignment,
      spinnerSize,
      showPeg,
    );
  }
}
