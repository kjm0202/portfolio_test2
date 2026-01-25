import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BokehBackground extends StatefulWidget {
  final int bubbleCount;
  final double maxBlurSigma;
  final double minRadius;
  final double maxRadius;
  final double speedScale;

  const BokehBackground({
    super.key,
    this.bubbleCount = 12,
    this.maxBlurSigma = 22,
    this.minRadius = 24,
    this.maxRadius = 96,
    this.speedScale = 1.0,
  });

  @override
  State<BokehBackground> createState() => _BokehBackgroundState();
}

class _BokehCircle {
  double x;
  double y;
  double vx; // px/sec
  double vy; // px/sec
  double radius;
  double blurSigma;
  Color color;
  MaskFilter maskFilter;

  _BokehCircle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.blurSigma,
    required this.color,
  }) : maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
}

class _BokehBackgroundState extends State<BokehBackground>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final Ticker _ticker;
  final List<_BokehCircle> _circles = [];
  Size _lastSize = Size.zero;
  late final Random _random;
  
  // Stopwatch로 시간 측정 (DateTime.now() 대신 - GC 압력 감소)
  final Stopwatch _stopwatch = Stopwatch();
  Duration _lastElapsed = Duration.zero;
  
  // CustomPainter 갱신을 위한 ValueNotifier
  final ValueNotifier<int> _frameNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _random = Random();
    _stopwatch.start();
    
    // Ticker 사용 (AnimationController보다 가벼움)
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _stopwatch.stop();
    _frameNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _lastElapsed = _stopwatch.elapsed;
        if (!_ticker.isActive) {
          _ticker.start();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        if (_ticker.isActive) {
          _ticker.stop();
        }
        break;
    }
  }

  void _ensureInit(Size size, ColorScheme colorScheme) {
    // 최초 생성
    if (_circles.isEmpty) {
      final cfg0 = _resolveConfig(size);
      _circles.addAll(
        List.generate(cfg0.count, (_) {
          final radius = _lerp(cfg0.minRadius, cfg0.maxRadius);
          final blurSigma =
              _random.nextDouble() * cfg0.maxBlurSigma * 0.8 +
              cfg0.maxBlurSigma * 0.2;

          final palette = [
            colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
            colorScheme.primary.withValues(alpha: 0.6),
            colorScheme.secondary.withValues(alpha: 0.6),
          ];
          final base = palette[_random.nextInt(palette.length)];
          final color = base.withValues(alpha: 0.18 + _random.nextDouble() * 0.22);

          final vx = _randomSpeed() * (_random.nextBool() ? 1 : -1);
          final vy = _randomSpeed() * (_random.nextBool() ? 1 : -1);
          final maxX0 = (size.width - radius * 2).clamp(0.0, size.width);
          final maxY0 = (size.height - radius * 2).clamp(0.0, size.height);
          return _BokehCircle(
            x: (maxX0 == 0) ? radius : (_random.nextDouble() * maxX0 + radius),
            y: (maxY0 == 0) ? radius : (_random.nextDouble() * maxY0 + radius),
            vx: vx,
            vy: vy,
            radius: radius,
            blurSigma: blurSigma,
            color: color,
          );
        }),
      );
      _lastSize = size;
      return;
    }

    // 사이즈가 동일하면 갱신 불필요
    if (_lastSize == size) return;

    // 사이즈 변경 처리
    final cfg = _resolveConfig(size);
    final sx = _lastSize.width == 0 ? 1.0 : size.width / _lastSize.width;
    final sy = _lastSize.height == 0 ? 1.0 : size.height / _lastSize.height;
    final scale = (sx + sy) / 2.0;

    for (final c in _circles) {
      c.x *= sx;
      c.y *= sy;
      c.radius = (c.radius * scale).clamp(cfg.minRadius, cfg.maxRadius);
      c.blurSigma = c.blurSigma.clamp(0.0, cfg.maxBlurSigma);
      c.maskFilter = MaskFilter.blur(BlurStyle.normal, c.blurSigma);
      c.vx *= scale;
      c.vy *= scale;
      
      final minX = c.radius;
      final maxX = size.width - c.radius;
      final minY = c.radius;
      final maxY = size.height - c.radius;
      if (maxX >= minX) c.x = c.x.clamp(minX, maxX);
      if (maxY >= minY) c.y = c.y.clamp(minY, maxY);
    }

    // 개수 보정
    if (_circles.length < cfg.count) {
      final need = cfg.count - _circles.length;
      for (int i = 0; i < need; i++) {
        final radius = _lerp(cfg.minRadius, cfg.maxRadius);
        final blurSigma =
            _random.nextDouble() * cfg.maxBlurSigma * 0.8 +
            cfg.maxBlurSigma * 0.2;
        final palette = [
          colorScheme.primary,
          colorScheme.secondary,
          colorScheme.tertiary,
          colorScheme.primary.withValues(alpha: 0.6),
          colorScheme.secondary.withValues(alpha: 0.6),
        ];
        final base = palette[_random.nextInt(palette.length)];
        final color = base.withValues(alpha: 0.14 + _random.nextDouble() * 0.2);
        final vx = _randomSpeed() * (_random.nextBool() ? 1 : -1);
        final vy = _randomSpeed() * (_random.nextBool() ? 1 : -1);
        final maxX0 = (size.width - radius * 2).clamp(0.0, size.width);
        final maxY0 = (size.height - radius * 2).clamp(0.0, size.height);
        _circles.add(
          _BokehCircle(
            x: (maxX0 == 0) ? radius : (_random.nextDouble() * maxX0 + radius),
            y: (maxY0 == 0) ? radius : (_random.nextDouble() * maxY0 + radius),
            vx: vx,
            vy: vy,
            radius: radius,
            blurSigma: blurSigma,
            color: color,
          ),
        );
      }
    } else if (_circles.length > cfg.count) {
      _circles.removeRange(cfg.count, _circles.length);
    }

    _lastSize = size;
  }

  double _lerp(double min, double max) =>
      min + (_random.nextDouble() * (max - min));

  double _randomSpeed() {
    return (12 + _random.nextDouble() * 18) * widget.speedScale;
  }

  void _onTick(Duration elapsed) {
    if (!mounted || _circles.isEmpty) return;
    
    // 델타 시간 계산 (초 단위)
    final dtSec = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;
    
    // 백그라운드 복귀 시 큰 점프 방지
    if (dtSec > 0.1 || dtSec <= 0) return;

    // 위치 업데이트 (setState 대신 직접 수정)
    for (final c in _circles) {
      double x = c.x + c.vx * dtSec;
      double y = c.y + c.vy * dtSec;

      final minX = c.radius;
      final maxX = _lastSize.width - c.radius;
      final minY = c.radius;
      final maxY = _lastSize.height - c.radius;

      if (x < minX) {
        x = minX;
        if (c.vx < 0) c.vx = -c.vx;
      } else if (x > maxX) {
        x = maxX;
        if (c.vx > 0) c.vx = -c.vx;
      }

      if (y < minY) {
        y = minY;
        if (c.vy < 0) c.vy = -c.vy;
      } else if (y > maxY) {
        y = maxY;
        if (c.vy > 0) c.vy = -c.vy;
      }

      c.x = x;
      c.y = y;
    }
    
    // CustomPainter만 갱신 (setState 대신)
    _frameNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IgnorePointer(
      ignoring: true,
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            _ensureInit(size, theme.colorScheme);

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface.withValues(alpha: 0.95),
                    theme.colorScheme.surface.withValues(alpha: 0.98),
                  ],
                ),
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: _frameNotifier,
                builder: (context, _, __) {
                  return CustomPaint(
                    painter: _BokehPainter(_circles),
                    isComplex: true,
                    willChange: true,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BokehPainter extends CustomPainter {
  final List<_BokehCircle> circles;

  _BokehPainter(this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final c in circles) {
      paint
        ..color = c.color
        ..maskFilter = c.maskFilter;
      canvas.drawCircle(Offset(c.x, c.y), c.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BokehPainter oldDelegate) => true;
}

class _BokehConfig {
  final int count;
  final double minRadius;
  final double maxRadius;
  final double maxBlurSigma;

  const _BokehConfig({
    required this.count,
    required this.minRadius,
    required this.maxRadius,
    required this.maxBlurSigma,
  });
}

extension _AdaptiveConfig on _BokehBackgroundState {
  _BokehConfig _resolveConfig(Size size) {
    final width = size.width;
    if (width < 600) {
      // 모바일
      return _BokehConfig(
        count: (widget.bubbleCount * 0.6).round().clamp(6, 24),
        minRadius: widget.minRadius * 0.7,
        maxRadius: widget.maxRadius * 0.8,
        maxBlurSigma: widget.maxBlurSigma * 0.85,
      );
    } else if (width < 1200) {
      // 태블릿
      return _BokehConfig(
        count: (widget.bubbleCount * 0.9).round().clamp(10, 28),
        minRadius: widget.minRadius * 0.9,
        maxRadius: widget.maxRadius * 1.0,
        maxBlurSigma: widget.maxBlurSigma * 1.0,
      );
    } else {
      // 데스크톱
      return _BokehConfig(
        count: (widget.bubbleCount * 1.3).round().clamp(16, 40),
        minRadius: widget.minRadius * 1.0,
        maxRadius: widget.maxRadius * 1.2,
        maxBlurSigma: widget.maxBlurSigma * 1.15,
      );
    }
  }
}
