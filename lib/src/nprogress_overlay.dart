import 'package:flutter/material.dart';
import 'nprogress_controller.dart';
import 'nprogress_singleton.dart';
import 'nprogress_widget.dart';

/// Overlay widget that wraps around your app content and renders NProgress on top.
class NProgressOverlay extends StatelessWidget {
  /// The app child widget.
  final Widget child;

  /// Optional controller. Uses [NProgress.controller] if null.
  final NProgressController? controller;

  const NProgressOverlay({
    super.key,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final NProgressController activeController = controller ?? NProgress.controller;

    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          NProgressWidget(controller: activeController),
        ],
      ),
    );
  }
}
