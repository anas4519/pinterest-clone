import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinterestRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const PinterestRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<PinterestRefreshIndicator> createState() =>
      _PinterestRefreshIndicatorState();
}

class _PinterestRefreshIndicatorState extends State<PinterestRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  double _dragOffset = 0.0;
  bool _isRefreshing = false;
  bool _hasTriggeredHaptics = false;
  double _lastDragOffset = 0.0;
  bool _isAtSquarePosition = false;

  final double _refreshThreshold = 100.0;
  final double _indicatorSize = 32.0;
  final double _minIndicatorSize = 16.0;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_isRefreshing) return false;

    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels < 0) {
        final double newOffset = notification.metrics.pixels.abs();
        final bool isDraggingDown = newOffset > _lastDragOffset;

        final double rotationProgress = (newOffset / _refreshThreshold) % 1.0;
        final bool isNearSquare =
            rotationProgress < 0.05 || rotationProgress > 0.95;

        if (!_spinController.isAnimating &&
            !_isAtSquarePosition &&
            newOffset > 0) {
          _spinController.repeat();
        }

        if (isDraggingDown &&
            isNearSquare &&
            _spinController.isAnimating &&
            !_isAtSquarePosition) {
          _spinController.stop();
          _spinController.value = 0;
          setState(() => _isAtSquarePosition = true);
          if (!_hasTriggeredHaptics) {
            HapticFeedback.mediumImpact();
            _hasTriggeredHaptics = true;
          }
        }

        if (!isDraggingDown && _isAtSquarePosition) {
          setState(() => _isAtSquarePosition = false);
          _spinController.repeat();
        }

        if (newOffset >= _refreshThreshold && !_spinController.isAnimating) {
          _spinController.repeat();
          setState(() => _isAtSquarePosition = false);
        }

        setState(() {
          _lastDragOffset = _dragOffset;
          _dragOffset = newOffset;
        });
      } else if (_dragOffset > 0) {
        setState(() {
          _lastDragOffset = _dragOffset;
          _dragOffset = 0.0;
        });
      }
    } else if (notification is ScrollEndNotification) {
      if (_dragOffset >= _refreshThreshold) {
        _startRefresh();
      } else {
        setState(() {
          _dragOffset = 0.0;
          _isAtSquarePosition = false;
        });
        _spinController.stop();
        _spinController.value = 0;
        _hasTriggeredHaptics = false;
      }
    }
    return false;
  }

  Future<void> _startRefresh() async {
    setState(() {
      _isRefreshing = true;
      _isAtSquarePosition = false;
    });

    if (!_spinController.isAnimating) _spinController.repeat();

    setState(() => _dragOffset = _refreshThreshold);

    await widget.onRefresh();

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _dragOffset = 0.0;
        _hasTriggeredHaptics = false;
        _isAtSquarePosition = false;
      });
      _spinController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double opacity = (_dragOffset / (_refreshThreshold * 0.5)).clamp(
      0.0,
      1.0,
    );

    final double sizeProgress = (_dragOffset / _refreshThreshold).clamp(
      0.0,
      1.0,
    );
    final double currentSize =
        _minIndicatorSize +
        ((_indicatorSize - _minIndicatorSize) * sizeProgress);

    final double topPosition = -currentSize + (_dragOffset * 0.8);

    final double rotationValue;
    if (_isAtSquarePosition) {
      rotationValue = 0;
    } else if (_spinController.isAnimating) {
      rotationValue = _spinController.value * 2 * math.pi;
    } else {
      rotationValue = 0;
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          widget.child,
          Positioned(
            top: topPosition,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: currentSize,
                  height: currentSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _spinController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _PinterestDotsPainter(
                          rotation: rotationValue,
                          color: Theme.of(context).iconTheme.color!,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinterestDotsPainter extends CustomPainter {
  final double rotation;
  final Color color;

  _PinterestDotsPainter({required this.rotation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final double distance = size.width * 0.18;
    final double dotRadius = size.width * 0.08;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    canvas.drawCircle(Offset(-distance, -distance), dotRadius, paint);
    canvas.drawCircle(Offset(distance, -distance), dotRadius, paint);
    canvas.drawCircle(Offset(distance, distance), dotRadius, paint);
    canvas.drawCircle(Offset(-distance, distance), dotRadius, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_PinterestDotsPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.color != color;
}
