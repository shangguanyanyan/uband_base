import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The signature of the [SliverValueLayoutBuilder] builder function.
typedef SliverValueLayoutWidgetBuilder<T> = Widget Function(
  BuildContext context,
  SliverValueConstraints<T> constraints,
);

class SliverValueConstraints<T> extends SliverConstraints {
  SliverValueConstraints({
    required this.value,
    required SliverConstraints constraints,
  }) : super(
          axisDirection: constraints.axisDirection,
          growthDirection: constraints.growthDirection,
          userScrollDirection: constraints.userScrollDirection,
          scrollOffset: constraints.scrollOffset,
          precedingScrollExtent: constraints.precedingScrollExtent,
          overlap: constraints.overlap,
          remainingPaintExtent: constraints.remainingPaintExtent,
          crossAxisExtent: constraints.crossAxisExtent,
          crossAxisDirection: constraints.crossAxisDirection,
          viewportMainAxisExtent: constraints.viewportMainAxisExtent,
          remainingCacheExtent: constraints.remainingCacheExtent,
          cacheOrigin: constraints.cacheOrigin,
        );

  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SliverValueConstraints<T>) return false;
    assert(other.debugAssertIsValid());
    return other.value == value &&
        other.axisDirection == axisDirection &&
        other.growthDirection == growthDirection &&
        other.scrollOffset == scrollOffset &&
        other.overlap == overlap &&
        other.remainingPaintExtent == remainingPaintExtent &&
        other.crossAxisExtent == crossAxisExtent &&
        other.crossAxisDirection == crossAxisDirection &&
        other.viewportMainAxisExtent == viewportMainAxisExtent &&
        other.remainingCacheExtent == remainingCacheExtent &&
        other.cacheOrigin == cacheOrigin;
  }

  @override
  int get hashCode {
    return Object.hash(
      axisDirection,
      growthDirection,
      scrollOffset,
      overlap,
      remainingPaintExtent,
      crossAxisExtent,
      crossAxisDirection,
      viewportMainAxisExtent,
      remainingCacheExtent,
      cacheOrigin,
      value,
    );
  }
}

/// Builds a sliver widget tree that can depend on its own
/// [SliverValueConstraints].
///
/// Similar to the [ValueLayoutBuilder] widget except its builder should return
/// a sliver widget, and [SliverValueLayoutBuilder] is itself a sliver.
/// The framework calls the [builder] function at layout time and provides the
/// current [SliverValueConstraints].
/// The [SliverValueLayoutBuilder]'s final [SliverGeometry] will match the
/// [SliverGeometry] of its child.
///
/// See also:
///
///  * [ValueLayoutBuilder], the non-sliver version of this widget.
class SliverValueLayoutBuilder<T> extends StatelessWidget {
  /// Creates a sliver widget that defers its building until layout.
  ///
  /// The [builder] argument must not be null.
  const SliverValueLayoutBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must return a non-null sliver widget.
  final SliverValueLayoutWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (BuildContext context, SliverConstraints constraints) {
        // Try to get the value from context
        final T? value = _getValueFromContext<T>(context);
        if (value != null) {
          return builder(
            context,
            SliverValueConstraints<T>(
              value: value,
              constraints: constraints,
            ),
          );
        }
        // Fallback to empty sliver if no value is provided
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  /// Helper method to get the value from context.
  /// This is a placeholder - in a real implementation, you would
  /// use an inherited widget or another mechanism to provide the value.
  T? _getValueFromContext<T>(BuildContext context) {
    // Try to find an inherited widget that provides the value
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_SliverValueProvider<T>>();
    return inherited?.value;
  }
}

/// An inherited widget that provides a value to its descendants.
class _SliverValueProvider<T> extends InheritedWidget {
  const _SliverValueProvider({
    Key? key,
    required this.value,
    required Widget child,
  }) : super(key: key, child: child);

  final T value;

  @override
  bool updateShouldNotify(_SliverValueProvider oldWidget) {
    return value != oldWidget.value;
  }
}

/// A widget that provides a value to SliverValueLayoutBuilder widgets in its subtree.
class SliverValueProvider<T> extends StatelessWidget {
  const SliverValueProvider({
    Key? key,
    required this.value,
    required this.child,
  }) : super(key: key);

  final T value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _SliverValueProvider<T>(
      value: value,
      child: child,
    );
  }
}
