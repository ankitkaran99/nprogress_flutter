import 'package:flutter/widgets.dart';
import 'nprogress_controller.dart';
import 'nprogress_options.dart';
import 'nprogress_overlay.dart';

/// Global singleton facade for NProgress.
/// Provides static methods to control top-level app progress.
abstract class NProgress {
  static final NProgressController _defaultController = NProgressController();

  /// Gets the default shared [NProgressController].
  static NProgressController get controller => _defaultController;

  /// Gets the current progress value (0.0 to 1.0) or null if stopped.
  static double? get status => _defaultController.status;

  /// Returns true if progress has started.
  static bool get isStarted => _defaultController.isStarted;

  /// Returns true if progress is currently rendered.
  static bool get isRendered => _defaultController.isRendered;

  /// Configures global options for NProgress.
  static void configure(NProgressOptions options) {
    _defaultController.configure(options);
  }

  /// Configures options using a modification builder.
  static void configureWith(NProgressOptions Function(NProgressOptions current) update) {
    _defaultController.configureWith(update);
  }

  /// Executes an async [task] with automatic NProgress lifecycle ([start] on start, [done] on finish).
  static Future<T> run<T>(Future<T> Function() task) {
    return _defaultController.run(task);
  }

  /// Starts the progress bar.
  static NProgressController start({bool reset = false}) {
    return _defaultController.start(reset: reset);
  }

  /// Sets progress to a specific value between 0.0 and 1.0.
  static NProgressController set(double amount) {
    return _defaultController.set(amount);
  }

  /// Increments progress.
  static NProgressController inc([double? amount]) {
    return _defaultController.inc(amount);
  }

  /// Completes and hides the progress bar.
  static NProgressController done({bool force = false}) {
    return _defaultController.done(force: force);
  }

  /// Immediately removes the progress bar.
  static NProgressController remove() {
    return _defaultController.remove();
  }

  /// Returns a builder for [MaterialApp.builder] to globally overlay NProgress over the entire app.
  ///
  /// Example:
  /// ```dart
  /// MaterialApp(
  ///   builder: NProgress.builder(),
  ///   home: const HomePage(),
  /// )
  /// ```
  static TransitionBuilder builder({
    NProgressController? controller,
    Widget Function(BuildContext context, Widget? child)? customBuilder,
  }) {
    return (BuildContext context, Widget? child) {
      final Widget appContent = customBuilder != null
          ? customBuilder(context, child)
          : (child ?? const SizedBox.shrink());

      return NProgressOverlay(
        controller: controller ?? _defaultController,
        child: appContent,
      );
    };
  }
}
