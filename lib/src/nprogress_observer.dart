import 'package:flutter/widgets.dart';
import 'nprogress_controller.dart';
import 'nprogress_singleton.dart';

/// A [NavigatorObserver] that automatically triggers NProgress during route navigation.
class NProgressNavigatorObserver extends NavigatorObserver {
  /// Custom controller if not using [NProgress.controller].
  final NProgressController? controller;

  /// Whether to trigger NProgress on route push. Default is true.
  final bool showOnPush;

  /// Whether to trigger NProgress on route pop. Default is true.
  final bool showOnPop;

  /// Whether to trigger NProgress on route replace. Default is true.
  final bool showOnReplace;

  /// Whether to ignore non-page routes (such as dialogs or popups). Default is true.
  final bool ignoreNonPageRoutes;

  NProgressNavigatorObserver({
    this.controller,
    this.showOnPush = true,
    this.showOnPop = true,
    this.showOnReplace = true,
    this.ignoreNonPageRoutes = true,
  });

  NProgressController get _activeController => controller ?? NProgress.controller;

  bool _shouldTrack(Route<dynamic>? route) {
    if (route == null) return false;
    if (ignoreNonPageRoutes && route is! PageRoute) return false;
    return true;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (showOnPush && _shouldTrack(route) && previousRoute != null) {
      _triggerNavigationProgress();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (showOnPop && _shouldTrack(route) && previousRoute != null) {
      _triggerNavigationProgress();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (showOnReplace && _shouldTrack(newRoute)) {
      _triggerNavigationProgress();
    }
  }

  void _triggerNavigationProgress() {
    _activeController.start();
    Future.microtask(() {
      _activeController.done();
    });
  }
}
