library ghost_font;

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that renders text using an optical illusion of moving noise.
///
/// The text is only readable because of motion perception.
/// If a screenshot is taken, the text becomes completely invisible
/// as it perfectly blends with the background noise.
class GhostFont extends StatefulWidget {
  /// The text to display.
  final String text;

  /// The size of the text.
  final double fontSize;

  /// The color of the noise dots. Defaults to black.
  final Color patternColor;

  /// The background color of the noise. Defaults to white.
  final Color backgroundColor;

  /// The speed of the animation.
  final double speed;

  /// The scale of the noise dots (larger values make chunky dots).
  final double noiseScale;

  /// The font weight. Defaults to bold for better visibility.
  final FontWeight fontWeight;

  /// The size of the noise texture generated in memory.
  /// 256 is usually enough because it tiles seamlessly.
  final int noiseTextureSize;

  const GhostFont({
    super.key,
    required this.text,
    this.fontSize = 48.0,
    this.patternColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.speed = 50.0,
    this.noiseScale = 2.0,
    this.fontWeight = FontWeight.bold,
    this.noiseTextureSize = 256,
  });

  @override
  State<GhostFont> createState() => _GhostFontState();
}

class _GhostFontState extends State<GhostFont>
    with SingleTickerProviderStateMixin {
  ui.Image? _noiseImage;
  late Ticker _ticker;
  double _timeBg = 0.0;
  double _timeFg = 0.0;
  double _lastTick = 0.0;

  @override
  void initState() {
    super.initState();
    _generateNoiseImage();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didUpdateWidget(covariant GhostFont oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.patternColor != widget.patternColor ||
        oldWidget.backgroundColor != widget.backgroundColor ||
        oldWidget.noiseTextureSize != widget.noiseTextureSize) {
      _generateNoiseImage();
    }
  }

  void _onTick(Duration elapsed) {
    final double currentTick = elapsed.inMicroseconds / 1000000.0; // seconds
    final double dt = currentTick - _lastTick;
    _lastTick = currentTick;

    setState(() {
      _timeBg += widget.speed * dt;
      _timeFg -= widget.speed * dt;
    });
  }

  Future<void> _generateNoiseImage() async {
    final width = widget.noiseTextureSize;
    final height = widget.noiseTextureSize;
    final pixels = Uint8List(width * height * 4);
    final random = Random();

    final r1 = (widget.patternColor.r * 255.0).round().clamp(0, 255);
    final g1 = (widget.patternColor.g * 255.0).round().clamp(0, 255);
    final b1 = (widget.patternColor.b * 255.0).round().clamp(0, 255);
    final a1 = (widget.patternColor.a * 255.0).round().clamp(0, 255);

    final r2 = (widget.backgroundColor.r * 255.0).round().clamp(0, 255);
    final g2 = (widget.backgroundColor.g * 255.0).round().clamp(0, 255);
    final b2 = (widget.backgroundColor.b * 255.0).round().clamp(0, 255);
    final a2 = (widget.backgroundColor.a * 255.0).round().clamp(0, 255);

    for (int i = 0; i < pixels.length; i += 4) {
      // 50% chance for pattern color, 50% for background color
      if (random.nextBool()) {
        pixels[i] = r1;
        pixels[i + 1] = g1;
        pixels[i + 2] = b1;
        pixels[i + 3] = a1;
      } else {
        pixels[i] = r2;
        pixels[i + 1] = g2;
        pixels[i + 2] = b2;
        pixels[i + 3] = a2;
      }
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (img) => completer.complete(img),
    );

    final image = await completer.future;
    if (mounted) {
      setState(() {
        _noiseImage = image;
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _noiseImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_noiseImage == null) {
      return const SizedBox.shrink(); // Wait for noise generation
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _GhostFontPainter(
            text: widget.text,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            noiseImage: _noiseImage!,
            timeBg: _timeBg,
            timeFg: _timeFg,
            noiseScale: widget.noiseScale,
          ),
        );
      },
    );
  }
}

class _GhostFontPainter extends CustomPainter {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final ui.Image noiseImage;
  final double timeBg;
  final double timeFg;
  final double noiseScale;

  _GhostFontPainter({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.noiseImage,
    required this.timeBg,
    required this.timeFg,
    required this.noiseScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Draw Background Noise
    final bgMatrix = Matrix4.identity()
      ..translate(timeBg, timeBg)
      ..scale(noiseScale);

    final bgPaint = Paint()
      ..shader = ImageShader(
        noiseImage,
        TileMode.repeated,
        TileMode.repeated,
        bgMatrix.storage,
        filterQuality: FilterQuality.none, // Keep edges crisp
      );

    canvas.drawRect(rect, bgPaint);

    // 2. Draw Text and Mask with Foreground Noise
    canvas.saveLayer(rect, Paint());

    // Draw the text (acts as a mask)
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: size.width, maxWidth: size.width);
    final textOffset = Offset(0, (size.height - textPainter.height) / 2);

    textPainter.paint(canvas, textOffset);

    // Draw Foreground Noise over the text, masked by srcIn
    final fgMatrix = Matrix4.identity()
      ..translate(timeFg, -timeFg) // Move in opposite direction
      ..scale(noiseScale);

    final fgPaint = Paint()
      ..blendMode = BlendMode.srcIn
      ..shader = ImageShader(
        noiseImage,
        TileMode.repeated,
        TileMode.repeated,
        fgMatrix.storage,
        filterQuality: FilterQuality.none,
      );

    canvas.drawRect(rect, fgPaint);

    canvas.restore(); // Composites the saveLayer back to the main canvas
  }

  @override
  bool shouldRepaint(covariant _GhostFontPainter oldDelegate) {
    return timeBg != oldDelegate.timeBg ||
        timeFg != oldDelegate.timeFg ||
        text != oldDelegate.text ||
        fontSize != oldDelegate.fontSize;
  }
}
