import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;
  final TextStyle? expandButtonStyle;
  final String expandText;
  final String collapseText;

  const ExpandableText({
    Key? key,
    required this.text,
    this.maxLines = 3,
    this.style,
    this.expandButtonStyle,
    this.expandText = "Read more",
    this.collapseText = "Show less",
  }) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _hasOverflow = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87,
    );
    
    final textStyle = widget.style ?? defaultStyle;
    final buttonStyle = widget.expandButtonStyle ?? 
      TextStyle(
        fontSize: textStyle.fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: textStyle,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: widget.maxLines,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);
        _hasOverflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: textStyle,
              maxLines: _expanded ? null : widget.maxLines,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (_hasOverflow)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _expanded ? widget.collapseText : widget.expandText,
                    style: buttonStyle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}