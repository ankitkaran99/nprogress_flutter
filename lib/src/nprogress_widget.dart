import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'nprogress_controller.dart';
import 'nprogress_options.dart';

/// Embedded visual widget for displaying NProgress progress bar and spinner.
class NProgressWidget extends StatefulWidget {
  /// Controller managing progress state.
  final NProgressController controller;

  const NProgressWidget({
    super.key,
    required this.controller,
  });

  @override
  State<NProgressWidget> createState() => _NProgressWidgetState();
}

class _NProgressWidgetState extends State<NProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinnerController;
  Timer? _fadeTimer;
  double _opacity = 0.0;
  bool _isVisible = false;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    widget.controller.addListener(_onControllerChanged);
    _onControllerChanged();
  }

  @override
  void didUpdateWidget(NProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
      _onControllerChanged();
    }
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    widget.controller.removeListener(_onControllerChanged);
    _spinnerController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final double? status = widget.controller.status;

    if (status != null && status > 0.0) {
      _fadeTimer?.cancel();
      _fadeTimer = null;

      if (!_isVisible) {
        setState(() {
          _isVisible = true;
          _opacity = 1.0;
          _currentValue = status;
        });
        if (widget.controller.options.showSpinner) {
          _spinnerController.repeat();
        }
      } else {
        setState(() {
          _opacity = 1.0;
          _currentValue = status;
        });
      }

      if (status >= 1.0) {
        _fadeTimer?.cancel();
        _fadeTimer = Timer(const Duration(milliseconds: 200), () {
          if (mounted && widget.controller.status == 1.0) {
            setState(() {
              _opacity = 0.0;
            });
          }
        });
      }
    } else {
      if (_isVisible) {
        _fadeTimer?.cancel();
        _fadeTimer = null;
        setState(() {
          _opacity = 0.0;
        });
      }
    }
  }

  void _onEndOpacity() {
    if (_opacity == 0.0 && mounted && !widget.controller.isStarted) {
      setState(() {
        _isVisible = false;
        _currentValue = 0.0;
      });
      _spinnerController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final NProgressOptions options = widget.controller.options;
    final Color barColor = options.color;
    final Gradient? barGradient = options.gradient;
    final NProgressPosition pos = options.position;

    return Semantics(
      label: 'Loading progress',
      value: '${(_currentValue * 100).toInt()}%',
      child: IgnorePointer(
        child: RepaintBoundary(
          child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 200),
          onEnd: _onEndOpacity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Progress Bar Track
              Positioned(
                top: pos == NProgressPosition.top ? options.padding.top : null,
                bottom: pos == NProgressPosition.bottom ? options.padding.bottom : null,
                left: options.padding.left,
                right: options.padding.right,
                height: options.height,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double barWidth = constraints.maxWidth;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Smoothly animated progress width
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(end: _currentValue),
                          duration: options.speed,
                          curve: options.curve,
                          builder: (context, value, child) {
                            final double currentWidth = (barWidth * value).clamp(0.0, barWidth);
                            return Container(
                              width: currentWidth,
                              height: options.height,
                              decoration: BoxDecoration(
                                color: barGradient == null ? barColor : null,
                                gradient: barGradient,
                              ),
                              child: options.showPeg && currentWidth > 0
                                  ? Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          right: 0,
                                          top: -3,
                                          bottom: -3,
                                          width: math.min(100.0, currentWidth),
                                          child: Transform.rotate(
                                            angle: 3 * math.pi / 180,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: barColor.withValues(alpha: 0.7),
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                  ),
                                                  BoxShadow(
                                                    color: barColor,
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Optional Spinner Widget
              if (options.showSpinner)
                Positioned(
                  top: pos == NProgressPosition.top
                      ? (options.padding.top + 15.0)
                      : null,
                  bottom: pos == NProgressPosition.bottom
                      ? (options.padding.bottom + 15.0)
                      : null,
                  right: 15.0 + options.padding.right,
                  child: RotationTransition(
                    turns: _spinnerController,
                    child: SizedBox(
                      width: options.spinnerSize,
                      height: options.spinnerSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
