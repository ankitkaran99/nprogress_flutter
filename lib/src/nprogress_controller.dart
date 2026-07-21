import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'nprogress_options.dart';

/// Controller managing the state, timers, and progress logic for NProgress.
class NProgressController extends ChangeNotifier {
  /// Current configuration options.
  NProgressOptions options;

  /// Current progress value from 0.0 to 1.0, or null when inactive/hidden.
  double? _status;

  Timer? _trickleTimer;
  final Random _random = Random();
  bool _isDisposed = false;

  /// Creates a new [NProgressController] instance.
  NProgressController({this.options = const NProgressOptions()});

  /// Current progress value (0.0 to 1.0). Null if progress is stopped.
  double? get status => _status;

  /// Returns true if progress has started (status is non-null and > 0).
  bool get isStarted => _status != null && _status! > 0.0;

  /// Returns true if progress is currently rendered / visible (status != null).
  bool get isRendered => _status != null;

  /// Returns true if this controller has been disposed.
  bool get isDisposed => _isDisposed;

  /// Updates the configuration options.
  void configure(NProgressOptions newOptions) {
    if (_isDisposed || options == newOptions) return;
    options = newOptions;

    if (isStarted && (_status ?? 0.0) < 1.0) {
      if (options.trickle) {
        _startTrickle();
      } else {
        _stopTrickle();
      }
    }

    notifyListeners();
  }

  /// Updates options using a builder function.
  void configureWith(NProgressOptions Function(NProgressOptions current) update) {
    configure(update(options));
  }

  /// Executes an async [task] while automatically calling [start] before execution and [done] on completion.
  Future<T> run<T>(Future<T> Function() task) async {
    start();
    try {
      return await task();
    } finally {
      done();
    }
  }

  /// Starts the progress bar.
  /// If already started, this is a no-op unless [reset] is true.
  NProgressController start({bool reset = false}) {
    if (_isDisposed) return this;
    if (!isStarted || reset) {
      set(options.minimum);
    }
    return this;
  }

  /// Sets the progress bar to a specific value between 0.0 and 1.0.
  NProgressController set(double amount) {
    if (_isDisposed) return this;
    final double clamped = amount.clamp(0.0, 1.0);
    _status = clamped;

    if (clamped >= 1.0) {
      _stopTrickle();
    } else if (options.trickle && _trickleTimer == null) {
      _startTrickle();
    }

    notifyListeners();
    return this;
  }

  /// Increments progress by [amount].
  /// If [amount] is omitted, a random increment based on current progress is calculated.
  NProgressController inc([double? amount]) {
    if (_isDisposed) return this;
    if (!isStarted) {
      return start();
    }

    double current = _status ?? 0.0;
    if (current >= 1.0) {
      return this;
    }

    double addition = 0.0;

    if (amount != null) {
      addition = amount;
    } else {
      if (current >= 0.0 && current < 0.2) {
        addition = _random.nextDouble() * 0.1;
      } else if (current >= 0.2 && current < 0.5) {
        addition = _random.nextDouble() * 0.04;
      } else if (current >= 0.5 && current < 0.8) {
        addition = _random.nextDouble() * 0.02;
      } else if (current >= 0.8 && current < 0.99) {
        addition = 0.005;
      } else {
        addition = 0.0;
      }
    }

    final double nextStatus = (current + addition).clamp(0.0, 0.994);
    return set(nextStatus);
  }

  /// Completes the progress bar by setting it to 1.0.
  /// If [force] is true, forces completion even if progress was not started.
  NProgressController done({bool force = false}) {
    if (_isDisposed) return this;
    if (!force && !isStarted) {
      return this;
    }

    // Add a random final push before completing if not already near full
    final double current = _status ?? 0.0;

    if (current < 1.0) {
      inc(0.3 + 0.5 * _random.nextDouble());
    }

    return set(1.0);
  }

  /// Stops and removes the progress bar immediately without completing animations.
  NProgressController remove() {
    if (_isDisposed) return this;
    _stopTrickle();
    _status = null;
    notifyListeners();
    return this;
  }

  void _startTrickle() {
    _trickleTimer?.cancel();
    _trickleTimer = Timer.periodic(options.trickleSpeed, (_) {
      if (isStarted && (_status ?? 0.0) < 0.994) {
        inc();
      } else {
        _stopTrickle();
      }
    });
  }

  void _stopTrickle() {
    _trickleTimer?.cancel();
    _trickleTimer = null;
  }

  @override
  void notifyListeners() {
    if (_isDisposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stopTrickle();
    super.dispose();
  }
}
