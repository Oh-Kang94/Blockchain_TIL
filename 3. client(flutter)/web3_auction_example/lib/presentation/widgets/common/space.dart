import 'package:flutter/material.dart';

enum SpaceProperties { raw, column }

class Space extends StatelessWidget {
  const Space(
    this.extent, {
    super.key,
    this.properties = SpaceProperties.raw,
    this.color = Colors.transparent,
  });
  final double extent;
  final SpaceProperties properties;
  final Color color;

  factory Space.defaultRaw() {
    return const Space(20);
  }

  factory Space.defaultColumn() {
    return const Space(
      20,
      properties: SpaceProperties.column,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: properties == SpaceProperties.column ? extent : null,
      width: properties == SpaceProperties.raw ? extent : null,
      color: color,
    );
  }
}
