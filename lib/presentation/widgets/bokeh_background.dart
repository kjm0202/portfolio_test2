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
    this.speedScale = 0.5,
  });

  @override
  State<BokehBackground> createState() => _BokehBackgroundState();
}

class _BokehCircle {
  Offset position;
  Offset velocity;
  double radius;
  double blurSigma;
  Color color;

  _BokehCircle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.blurSigma,
    required this.color,
  });
}

class _BokehBackgroundState extends State<BokehBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_BokehCircle> _circles = [];
  Size _lastSize = Size.zero;
  late final Random _random;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _controller =
        AnimationController(vsync: this, duration: widget.duration)
          ..addListener(_tick)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.removeListener(_tick);
    _controller.dispose();
    super.dispose();
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
            colorScheme.primary.withOpacity(0.6),
            colorScheme.secondary.withOpacity(0.6),
          ];
          final base = palette[_random.nextInt(palette.length)];
          final color = base.withOpacity(0.18 + _random.nextDouble() * 0.22);

          return _BokehCircle(
            position: Offset(
              _random.nextDouble() * size.width,
              _random.nextDouble() * size.height,
            ),
            velocity: Offset(
              ((_random.nextDouble() * 0.6 + 0.2) *
                      (_random.nextBool() ? 1 : -1)) *
                  widget.speedScale,
              ((_random.nextDouble() * 0.6 + 0.2) *
                      (_random.nextBool() ? 1 : -1)) *
                  widget.speedScale,
            ),
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
      c.position = Offset(c.position.dx * sx, c.position.dy * sy);
      c.radius = (c.radius * scale).clamp(cfg.minRadius, cfg.maxRadius);
      c.blurSigma = c.blurSigma.clamp(0.0, cfg.maxBlurSigma);
      c.velocity = Offset(c.velocity.dx * scale, c.velocity.dy * scale);
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
          colorScheme.primary.withOpacity(0.6),
          colorScheme.secondary.withOpacity(0.6),
        ];
        final base = palette[_random.nextInt(palette.length)];
        final color = base.withOpacity(0.14 + _random.nextDouble() * 0.2);
        _circles.add(
          _BokehCircle(
            position: Offset(
              _random.nextDouble() * size.width,
              _random.nextDouble() * size.height,
            ),
            velocity: Offset(
              ((_random.nextDouble() * 0.6 + 0.2) *
                      (_random.nextBool() ? 1 : -1)) *
                  widget.speedScale,
              ((_random.nextDouble() * 0.6 + 0.2) *
                      (_random.nextBool() ? 1 : -1)) *
                  widget.speedScale,
            ),
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

  void _tick() {
    if (!mounted) return;
    setState(() {
      // 위치 업데이트 (천천히 이동)
      for (final c in _circles) {
        final next = c.position + c.velocity;
        double x = next.dx;
        double y = next.dy;

        // 화면 밖으로 나가면 반사
        if (x - c.radius < -20 || x + c.radius > _lastSize.width + 20) {
          c.velocity = Offset(-c.velocity.dx, c.velocity.dy);
          x = c.position.dx + c.velocity.dx;
        }
        if (y - c.radius < -20 || y + c.radius > _lastSize.height + 20) {
          c.velocity = Offset(c.velocity.dx, -c.velocity.dy);
          y = c.position.dy + c.velocity.dy;
        }
        c.position = Offset(x, y);
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
                  theme.colorScheme.surface.withOpacity(0.95),
                  theme.colorScheme.surface.withOpacity(0.98),
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
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, c.blurSigma);
      canvas.drawCircle(c.position, c.radius, paint);
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
