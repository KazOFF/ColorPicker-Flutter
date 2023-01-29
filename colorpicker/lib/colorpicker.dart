library colorpicker;

import 'dart:math';

import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  late HSVColor hsvColor;
  late HarmonyTypes harmonyType;
  late bool isTouchable;
  Function(List<HSVColor>)? colorChanged;
  late BuildContext _ctx;
  List<HSVColor> colorsList = [];

  ColorPicker(
      {super.key,
      this.hsvColor = const HSVColor.fromAHSV(1, 0, 0, 1),
      this.harmonyType = HarmonyTypes.none,
      this.isTouchable = true,
      this.colorChanged}) {
    harmonize();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return _createColorWheel();
  }

  Widget _createColorWheel() {
    return GestureDetector(
      onTap: () {},
      onTapDown: isTouchable
          ? ((details) => _wheelTapped(details.localPosition))
          : (details) {},
      onVerticalDragUpdate: isTouchable
          ? ((details) => _wheelTapped(details.localPosition))
          : (details) {},
      onHorizontalDragUpdate: isTouchable
          ? ((details) => _wheelTapped(details.localPosition))
          : (details) {},
      child: CustomPaint(
        painter: _ColorWheelPainter(colorsList),
      ),
    );
  }

  _wheelTapped(Offset offset) {
    double wheelSize = min(_ctx.size!.width * 0.85, _ctx.size!.height);

    double cx = offset.dx - wheelSize / 2;
    double cy = offset.dy - wheelSize / 2;
    double d = sqrt(cx * cx + cy * cy);

    if (d <= wheelSize / 2) {
      double hue = (degrees(atan2(cy, cx)) + 360) % 360;
      double saturation = max(0, min(1, (d / (wheelSize / 2))));
      double value = hsvColor.value;

      hsvColor = HSVColor.fromAHSV(1, hue, saturation, value);
      _callbackColors();
    } else if ((offset.dx >= (wheelSize + wheelSize * 0.05)) &&
        (offset.dy >= 0) &&
        (offset.dy <= wheelSize)) {
      double hue = hsvColor.hue;
      double saturation = hsvColor.saturation;
      double value = 1 - (offset.dy / wheelSize);
      hsvColor = HSVColor.fromAHSV(1, hue, saturation, value);
      _callbackColors();
    }
  }

  void _callbackColors() {
    harmonize();

    if (colorChanged != null) {
      colorChanged!(colorsList);
    }
  }

  void harmonize() {
    colorsList.clear();

    switch (harmonyType) {
      case HarmonyTypes.complementary:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 180) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.splitComplementary:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 150) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 210) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.analogous:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 330) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 30) % 360, hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.analogousAccent:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 330) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 30) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 180) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.triadic:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 120) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 240) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.square:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 90) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 180) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 270) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.tetradicPlus:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 60) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 180) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 240) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.tetradicMinus:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 120) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 180) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 300) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.clash:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 90) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 270) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.fiveTone:
        colorsList.add(HSVColor.fromAHSV(
            1, hsvColor.hue % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 60) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 120) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 240) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 300) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      case HarmonyTypes.sixTone:
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 60) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(
            1, (hsvColor.hue + 90) % 360, hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 210) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 240) % 360,
            hsvColor.saturation, hsvColor.value));
        colorsList.add(HSVColor.fromAHSV(1, (hsvColor.hue + 300) % 360,
            hsvColor.saturation, hsvColor.value));
        break;
      default:
        colorsList.add(hsvColor);
        break;
    }
  }
}

enum HarmonyTypes {
  none,
  complementary,
  splitComplementary,
  analogous,
  analogousAccent,
  triadic,
  square,
  tetradicPlus,
  tetradicMinus,
  clash,
  fiveTone,
  sixTone
}

class _ColorWheelPainter extends CustomPainter {
  static const List<Color> sweepColors = [
    Color(0xFFFF0000),
    Color(0xFFFF8000),
    Color(0xFFFFFF00),
    Color(0xFF80FF00),
    Color(0xFF00FF00),
    Color(0xFF00FF80),
    Color(0xFF00FFFF),
    Color(0xFF0080FF),
    Color(0xFF0000FF),
    Color(0xFF8000FF),
    Color(0xFFFF00FF),
    Color(0xFFFF0080),
    Color(0xFFFF0000),
  ];

  static const List<Color> radialColors = [
    Color(0xFFFFFFFF),
    Color(0x00FFFFFF),
  ];

  final List<HSVColor> _colorList;
  HSVColor _currentColor = const HSVColor.fromAHSV(1, 0, 0, 1);

  _ColorWheelPainter(this._colorList) {
    _currentColor = _colorList[0];
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint.enableDithering = true;
    double minSize = min(size.width * 0.85, size.height);

    //Paint Color Wheel
    Paint colorWheelPaint = Paint()..isAntiAlias = true;
    Size wheelSize = Size(minSize, minSize);
    Rect wheelRect = Rect.fromCircle(
      center: Offset(wheelSize.width / 2, wheelSize.height / 2),
      radius: wheelSize.width / 2,
    );

    SweepGradient sweepGradient = const SweepGradient(colors: sweepColors);
    colorWheelPaint.shader = sweepGradient.createShader(wheelRect);
    canvas.drawCircle(Offset(wheelSize.width / 2, wheelSize.height / 2),
        wheelSize.width / 2, colorWheelPaint);

    RadialGradient radialGradient = const RadialGradient(colors: radialColors);
    colorWheelPaint.shader = radialGradient.createShader(wheelRect);
    canvas.drawCircle(Offset(wheelSize.width / 2, wheelSize.height / 2),
        wheelSize.width / 2, colorWheelPaint);

    //Draw Value slider
    Paint valueSliderPaint = Paint()..isAntiAlias = true;
    Size valueSliderSize = Size(minSize * 0.1, minSize);
    //double barStartPoint = size.width - barSize.width;
    double valueSliderStartPoint = minSize + minSize * 0.05;
    Rect valueSliderRect = Rect.fromLTWH(valueSliderStartPoint, 0,
        valueSliderSize.width, valueSliderSize.height);

    LinearGradient linearGradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        tileMode: TileMode.repeated,
        colors: [
          Colors.black,
          HSVColor.fromAHSV(1, _currentColor.hue, _currentColor.saturation, 1)
              .toColor()
        ]);
    valueSliderPaint.shader = linearGradient.createShader(valueSliderRect);
    canvas.drawRect(valueSliderRect, valueSliderPaint);

    //Draw Wheel Pointer
    Paint wheelPointerPaint = Paint()
      ..isAntiAlias = true
      ..color = const Color.fromARGB(128, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (HSVColor c in _colorList) {
      double hueAngle = radians(c.hue);
      double center = wheelSize.width / 2;

      double colorPointX = (cos(hueAngle) * c.saturation * center) + center;
      double colorPointY = (sin(hueAngle) * c.saturation * center) + center;

      double pointerRadius = 0.075 * center;
      double pointerX = (colorPointX - pointerRadius / 2);
      double pointerY = (colorPointY - pointerRadius / 2);

      Rect wheelPointerRect = Rect.fromLTRB(pointerX, pointerY,
          pointerX + pointerRadius, pointerY + pointerRadius);
      canvas.drawOval(wheelPointerRect, wheelPointerPaint);
    }

    //Draw Value Pointer
    HSVColor color = HSVColor.fromAHSV(1, 0, 0, 1 - _currentColor.value);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = color.toColor();

    double value =
        valueSliderSize.height - (_currentColor.value * valueSliderSize.height);
    canvas.drawLine(Offset(valueSliderStartPoint, value),
        Offset(valueSliderStartPoint + valueSliderSize.width, value), paint);
  } // paint

  @override
  bool shouldRepaint(_ColorWheelPainter old) => true;
}

double degrees(double radians) {
  return radians * 180 / pi;
}

double radians(double degrees) {
  return degrees * pi / 180;
}
