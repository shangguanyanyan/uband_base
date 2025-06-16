import 'package:flutter/widgets.dart';

/// The signature of the [ValueLayoutBuilder] builder function.
typedef ValueLayoutWidgetBuilder<T> = Widget Function(
  BuildContext context,
  BoxValueConstraints<T> constraints,
);

class BoxValueConstraints<T> extends BoxConstraints {
  BoxValueConstraints({
    required this.value,
    required BoxConstraints constraints,
  }) : super(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
          minHeight: constraints.minHeight,
          maxHeight: constraints.maxHeight,
        );

  final T value;

  @override
  bool operator ==(Object other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) return true;
    if (other is! BoxValueConstraints<T>) return false;
    final BoxValueConstraints<T> typedOther = other;
    assert(typedOther.debugAssertIsValid());
    return value == typedOther.value &&
        minWidth == typedOther.minWidth &&
        maxWidth == typedOther.maxWidth &&
        minHeight == typedOther.minHeight &&
        maxHeight == typedOther.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return Object.hash(minWidth, maxWidth, minHeight, maxHeight, value);
  }
}

/// Builds a widget tree that can depend on the parent widget's size and a extra
/// value.
///
/// Similar to the [LayoutBuilder] widget except that the constraints contains
/// an extra value.
///
/// See also:
///
///  * [LayoutBuilder].
///  * [SliverValueLayoutBuilder], the sliver version of this widget.
class ValueLayoutBuilder<T> extends StatelessWidget {
  /// Creates a widget that defers its building until layout.
  ///
  /// The [builder] argument must not be null.
  const ValueLayoutBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must not return null.
  final ValueLayoutWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // For now, we'll use a default value. In a real implementation,
        // you would need to provide the value through an inherited widget
        // or another mechanism.
        final T? value = _getValueFromContext<T>(context);
        if (value != null) {
          return builder(
            context,
            BoxValueConstraints<T>(
              value: value,
              constraints: constraints,
            ),
          );
        }
        // Fallback to empty container if no value is provided
        return Container();
      },
    );
  }

  /// Helper method to get the value from context.
  /// This is a placeholder - in a real implementation, you would
  /// use an inherited widget or another mechanism to provide the value.
  T? _getValueFromContext<T>(BuildContext context) {
    // Try to find an inherited widget that provides the value
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ValueProvider<T>>();
    return inherited?.value;
  }
}

/// An inherited widget that provides a value to its descendants.
class _ValueProvider<T> extends InheritedWidget {
  const _ValueProvider({
    Key? key,
    required this.value,
    required Widget child,
  }) : super(key: key, child: child);

  final T value;

  @override
  bool updateShouldNotify(_ValueProvider oldWidget) {
    return value != oldWidget.value;
  }
}

/// A widget that provides a value to ValueLayoutBuilder widgets in its subtree.
class ValueProvider<T> extends StatelessWidget {
  const ValueProvider({
    Key? key,
    required this.value,
    required this.child,
  }) : super(key: key);

  final T value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _ValueProvider<T>(
      value: value,
      child: child,
    );
  }
}
