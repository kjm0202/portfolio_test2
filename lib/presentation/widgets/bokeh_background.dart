import 'dart:math';

import 'package:flutter/material.dart';

class BokehBackground extends StatefulWidget {
  final int bubbleCount;
  final Duration duration;
  final double maxBlurSigma;
  final double minRadius;
  final double maxRadius;
  final double speedScale;

  const BokehBackground({
    super.key,
    this.bubbleCount = 12,
    this.duration = const Duration(milliseconds: 1000000),
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
  late final AnimationController _controller;
  final List<_BokehCircle> _circles = [];
  Size _lastSize = Size.zero;
  late final Random _random;
  int _lastUpdateMs = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _random = Random();
    _controller =
        AnimationController(vsync: this, duration: widget.duration)
          ..addListener(_tick)
          ..repeat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_tick);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _lastUpdateMs = DateTime.now().millisecondsSinceEpoch;
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        if (_controller.isAnimating) {
          _controller.stop();
        }
        break;
    }
  }

  void _ensureInit(Size size, ColorScheme colorScheme) {
    // 최초 생성: 현재 화면 크기 기준으로 한 번만 생성
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

    // 사이즈 변경: 기존 원들을 유지하면서 스케일/보정 → 끊김 최소화
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
      // 화면 안쪽으로 클램프
      final minX = c.radius;
      final maxX = (_lastSize.width).clamp(0.0, double.infinity) - c.radius;
      final minY = c.radius;
      final maxY = (_lastSize.height).clamp(0.0, double.infinity) - c.radius;
      if (maxX >= minX) c.x = c.x.clamp(minX, maxX);
      if (maxY >= minY) c.y = c.y.clamp(minY, maxY);
    }

    // 개수 보정: 목표 개수와 차이가 나면 부드럽게 조정
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
    // px/sec 기준 속도. speedScale로 전역 감속/가속 조절
    return (12 + _random.nextDouble() * 18) * widget.speedScale;
  }

  void _tick() {
    if (!mounted) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_lastUpdateMs == 0) _lastUpdateMs = now;
    final dtSec = (now - _lastUpdateMs) / 1000.0;
    // 백그라운드/복귀 직후 큰 점프 방지
    if (dtSec > 0.25) {
      _lastUpdateMs = now;
      return;
    }
    // 30fps 수준으로만 갱신해 부하·GC 압력 감소
    if (dtSec < 1 / 30) return;
    _lastUpdateMs = now;

    setState(() {
      for (final c in _circles) {
        double x = c.x + c.vx * dtSec;
        double y = c.y + c.vy * dtSec;

        final minX = c.radius;
        final maxX = _lastSize.width - c.radius;
        final minY = c.radius;
        final maxY = _lastSize.height - c.radius;

        if (x < minX) {
          x = minX;
          if (c.vx < 0) c.vx = -c.vx; // 방향 반전하되 경계 밖으로는 보내지 않음
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IgnorePointer(
      ignoring: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _ensureInit(size, theme.colorScheme);

          return Container(
            // 베이스 그라데이션
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
            child: CustomPaint(
              painter: _BokehPainter(_circles),
              isComplex: true,
              willChange: true,
            ),
          );
        },
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
      // 태블릿/폴더블
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
