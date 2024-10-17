import 'package:flutter/material.dart';

enum SpaceProperties { raw, column }

class Space extends StatelessWidget {
  const Space({
    super.key,
    this.extent = 20,
    this.properties = SpaceProperties.raw,
    this.color = Colors.transparent,
  });
  final double extent;
  final SpaceProperties properties;
  final Color color;

  factory Space.defaultRaw() {
    return const Space();
  }

  factory Space.defaultColumn() {
    return const Space(
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
