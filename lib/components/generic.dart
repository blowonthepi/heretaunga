import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GenericComponent extends StatefulWidget {
  GenericComponent({
    this.title,
    this.subtitle,
    this.children,
    this.iconChildren,
    this.elevation = 8,
    this.backgroundColor = Colors.transparent,
    this.isExpanded = false,
  });

  final Widget title;
  final Widget subtitle;
  final List<String> children;
  final List<IconData> iconChildren;
  final double elevation;
  final Color backgroundColor;
  final bool isExpanded;

  @override
  _GenericComponentState createState() => _GenericComponentState();
}

class _GenericComponentState extends State<GenericComponent>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width,
          minWidth: size.width,
          maxHeight: widget.isExpanded ? 200 : double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            color: widget.backgroundColor,
            elevation: widget.elevation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 200),
                child: Flex(
                  direction:
                      widget.isExpanded ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: widget.isExpanded ? 1 : 4,
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: widget.isExpanded
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            widget.title != null
                                ? Flexible(child: widget.title)
                                : Container(),
                            widget.subtitle != null
                                ? Flexible(child: widget.subtitle)
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    widget.children.length == widget.iconChildren.length
                        ? Flexible(
                            flex: widget.isExpanded ? 1 : 6,
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (int i = 0;
                                      i < widget.children.length;
                                      i++)
                                    infoWidgets(
                                        size,
                                        widget.iconChildren[i],
                                        widget.children[i],
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1
                                            .color),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoWidgets(Size size, IconData icon, String title, Color color) {
    if (title != null) {
      return Expanded(
        flex: 3,
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: AutoSizeText(
                title,
                maxLines: 1,
                minFontSize: 10,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(flex: 3, child: Container());
    }
  }
}
