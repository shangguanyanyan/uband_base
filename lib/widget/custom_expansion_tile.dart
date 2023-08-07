import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// 仿照expansion_tile自定义的展开收起控件
/// 下方展开内容可以是任意widget
class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({Key? key,
    required this.tileBuilder,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.iconSize = 24,
    this.iconColor = const Color(0xffcccccc),
    this.alignment = Alignment.center,
    this.isBorder = true,
    this.enableClickChildrenToShrink = true, this.keepAlive = false})
      : super(key: key);

  /// 展开时的回调
  final ValueChanged<bool>? onExpansionChanged;
  final WidgetBuilder tileBuilder;

  final List<Widget> children;

  /// 展开按钮
  final Widget? trailing;

  final bool initiallyExpanded;

  final bool isBorder;

  final double iconSize;

  final Color iconColor;

  final Alignment alignment;

  final bool enableClickChildrenToShrink;
  final bool keepAlive;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static final Animatable<double> _easeOutTween =
  CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
  CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
  Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded =
        PageStorage.of(context)?.readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged!(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        border: widget.isBorder
            ? Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        )
            : Border(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: _handleTap,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: <Widget>[
                widget.tileBuilder(context),
                Positioned(
                  right: 10,
                  child: widget.trailing ??
                      RotationTransition(
                        turns: _iconTurns,
                        child: Icon(
                          Icons.expand_more,
                          color: widget.iconColor,
                          size: widget.iconSize,
                        ),
                      ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.enableClickChildrenToShrink ? _handleTap : () {},
            child: ClipRect(
              child: Align(
                alignment: widget.alignment,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1!.color
      ..end = theme.secondaryHeaderColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.secondaryHeaderColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool closed = !_isExpanded && _controller.isDismissed;

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed
          ? null
          : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.children),
    );
  }
}
