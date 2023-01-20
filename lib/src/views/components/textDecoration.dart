import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextCustomDecoration extends StatelessWidget {
  const TextCustomDecoration({
    Key? key,
    required this.text,
    required this.color,
    required this.size,
    required this.isOverflow,
    required this.align,
  }) : super(key: key);

  final String text;
  final Color color;
  final double size;
  final TextAlign align;
  final bool isOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      overflow: (isOverflow) ? TextOverflow.ellipsis : null,
      style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headline4, fontSize: size, color: color),
    );
  }
}
