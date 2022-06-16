import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import '../sticky_and_expandable_list.dart';

///Section widget information.
class ExpandableSectionContainerInfo {
  Widget? header;
  Widget? content;
  final SliverChildBuilderDelegate? childDelegate;
  final int listIndex;
  final List<int> sectionRealIndexes;
  final bool separated;

  final ExpandableListController controller;
  final int sectionIndex;
  final bool sticky;
  final bool overlapsContent;

  ExpandableSectionContainerInfo(
      {this.header,
      this.content,
      this.childDelegate,
      required this.listIndex,
      required this.sectionRealIndexes,
      required this.separated,
      required this.controller,
      required this.sectionIndex,
      required this.sticky,
      required this.overlapsContent});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpandableSectionContainerInfo &&
          runtimeType == other.runtimeType &&
          header == other.header &&
          content == other.content &&
          childDelegate == other.childDelegate &&
          listIndex == other.listIndex &&
          sectionRealIndexes == other.sectionRealIndexes &&
          separated == other.separated &&
          controller == other.controller &&
          sectionIndex == other.sectionIndex &&
          sticky == other.sticky &&
          overlapsContent == other.overlapsContent;

  @override
  int get hashCode =>
      (header?.hashCode ?? 0) ^
      (content?.hashCode ?? 0) ^
      (childDelegate?.hashCode ?? 0) ^
      listIndex.hashCode ^
      sectionRealIndexes.hashCode ^
      separated.hashCode ^
      controller.hashCode ^
      sectionIndex.hashCode ^
      sticky.hashCode ^
      overlapsContent.hashCode;
}

///Section widget that contains header and content widget.
///You can return a custom [ExpandableSectionContainer]
///by [SliverExpandableChildDelegate.sectionBuilder], but only
///[header] and [content] field could be changed.
///
class ExpandableSectionContainer extends MultiChildRenderObjectWidget {
  final ExpandableSectionContainerInfo info;

  ExpandableSectionContainer({
    Key? key,
    required this.info,
  }) : super(key: key, children: [info.content!, info.header!]);

  @override
  RenderExpandableSectionContainer createRenderObject(BuildContext context) {
    var renderSliver =
        context.findAncestorRenderObjectOfType<RenderExpandableSliverList>()!;
    return RenderExpandableSectionContainer(
      renderSliver: renderSliver,
      scrollable: Scrollable.of(context)!,
      controller: this.info.controller,
      sticky: this.info.sticky,
      overlapsContent: this.info.overlapsContent,
      listIndex: this.info.listIndex,
      sectionRealIndexes: this.info.sectionRealIndexes,
      separated: this.info.separated,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderExpandableSectionContainer renderObject) {
    renderObject
      ..scrollable = Scrollable.of(context)!
      ..controller = this.info.controller
      ..sticky = this.info.sticky
      ..overlapsContent = this.info.overlapsContent
      ..listIndex = this.info.listIndex
      ..sectionRealIndexes = this.info.sectionRealIndexes
      ..separated = this.info.separated;
  }
}

///Render [ExpandableSectionContainer]
class RenderExpandableSectionContainer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  bool _sticky;
  bool _overlapsContent;
  ScrollableState _scrollable;
  ExpandableListController _controller;
  RenderExpandableSliverList _renderSliver;
  int _listIndex;
  int _stickyIndex = -1;

  ///[sectionIndex, section in SliverList index].
  List<int> _sectionRealIndexes;

  /// is SliverList has separator
  bool _separated;

  RenderExpandableSectionContainer({
    required ScrollableState scrollable,
    required ExpandableListController controller,
    sticky = true,
    overlapsContent = false,
    int listIndex = -1,
    List<int> sectionRealIndexes = const [],
    bool separated = false,
    required RenderExpandableSliverList renderSliver,
  })  : _scrollable = scrollable,
        _controller = controller,
        _sticky = sticky,
        _overlapsContent = overlapsContent,
        _listIndex = listIndex,
        _sectionRealIndexes = sectionRealIndexes,
        _separated = separated,
        _renderSliver = renderSliver;

  List<int> get sectionRealIndexes => _sectionRealIndexes;

  set sectionRealIndexes(List<int> value) {
    if (_sectionRealIndexes == value) {
      return;
    }
    _sectionRealIndexes = value;
    markNeedsLayout();
  }

  bool get separated => _separated;

  set separated(bool value) {
    if (_separated == value) {
      return;
    }
    _separated = value;
    markNeedsLayout();
  }

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    // print("$runtimeType  update scrollable: ${_renderSliver.sizeChanged}");

    //when collapse last section, Sliver list not callback correct offset, so layout again.
    if (_renderSliver.sizeChanged) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        if (attached) {
          markNeedsLayout();
        }
      });
    }
    if (_scrollable == value) {
      return;
    }
    final ScrollableState oldValue = _scrollable;
    _scrollable = value;
    markNeedsLayout();
    if (attached) {
      oldValue.widget.controller?.removeListener(markNeedsLayout);
      if (_sticky) {
        _scrollable.widget.controller?.addListener(markNeedsLayout);
      }
    }
  }

  ExpandableListController get controller => _controller;

  set controller(ExpandableListController value) {
    if (_controller == value) {
      return;
    }
    _controller = value;
    markNeedsLayout();
  }

  bool get sticky => _sticky;

  set sticky(bool value) {
    if (_sticky == value) {
      return;
    }
    _sticky = value;
    markNeedsLayout();
    if (attached && !_sticky) {
      _scrollable.widget.controller?.removeListener(markNeedsLayout);
    }
  }

  bool get overlapsContent => _overlapsContent;

  set overlapsContent(bool value) {
    if (_overlapsContent == value) {
      return;
    }
    _overlapsContent = value;
    markNeedsLayout();
  }

  int get listIndex => _listIndex;

  set listIndex(int value) {
    if (_listIndex == value) {
      return;
    }
    _listIndex = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData)
      child.parentData = MultiChildLayoutParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (sticky) {
      _scrollable.widget.controller?.addListener(markNeedsLayout);
    }
  }

  @override
  void detach() {
    _scrollable.widget.controller?.removeListener(markNeedsLayout);
    super.detach();
  }

  RenderBox get content => firstChild!;

  RenderBox get header => lastChild!;

  @override
  double computeMinIntrinsicWidth(double height) {
    return _overlapsContent
        ? max(header.getMinIntrinsicWidth(height),
            content.getMinIntrinsicWidth(height))
        : header.getMinIntrinsicWidth(height) +
            content.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _overlapsContent
        ? max(header.getMaxIntrinsicWidth(height),
            content.getMaxIntrinsicWidth(height))
        : header.getMaxIntrinsicWidth(height) +
            content.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _overlapsContent
        ? max(header.getMinIntrinsicHeight(width),
            content.getMinIntrinsicHeight(width))
        : header.getMinIntrinsicHeight(width) +
            content.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _overlapsContent
        ? max(header.getMaxIntrinsicHeight(width),
            content.getMaxIntrinsicHeight(width))
        : header.getMaxIntrinsicHeight(width) +
            content.getMaxIntrinsicHeight(width);
  }

  @override
  void performLayout() {
    assert(childCount == 2);

    //layout two child
    BoxConstraints exactlyConstraints = constraints.loosen();
    header.layout(exactlyConstraints, parentUsesSize: true);
    content.layout(exactlyConstraints, parentUsesSize: true);

    //header's size should not large than content's size.
    double headerLogicalExtent = _overlapsContent ? 0 : header.size.height;

    double width =
        max(constraints.minWidth, max(header.size.width, content.size.width));
    double height = max(constraints.minHeight,
        max(header.size.height, headerLogicalExtent + content.size.height));
    size = Size(width, height);
    assert(size.width == constraints.constrainWidth(width));
    assert(size.height == constraints.constrainHeight(height));

    //calc content offset
    positionChild(content, Offset(0, headerLogicalExtent));

    checkRefreshContainerOffset();

    double sliverListOffset = _getSliverListVisibleScrollOffset();
    double currContainerOffset = -1;
    if (_listIndex < _controller.containerOffsets.length) {
      currContainerOffset = _controller.containerOffsets[_listIndex]!;
    }
    bool containerPainted = (_listIndex == 0 && currContainerOffset == 0) ||
        currContainerOffset > 0;
    if (!containerPainted) {
      positionChild(header, Offset.zero);
      return;
    }
    double minScrollOffset = _listIndex >= _controller.containerOffsets.length
        ? 0
        : _controller.containerOffsets[_listIndex]!;
    double maxScrollOffset = minScrollOffset + size.height;

    //when [ExpandableSectionContainer] size changed, SliverList may give a wrong
    // layoutOffset at first time, so check offsets for store right layoutOffset
    // in [containerOffsets].
    if (_listIndex < _controller.containerOffsets.length) {
      currContainerOffset = _controller.containerOffsets[_listIndex]!;
      int nextListIndex = _listIndex + 1;
      if (nextListIndex < _controller.containerOffsets.length &&
          _controller.containerOffsets[nextListIndex]! < maxScrollOffset) {
        _controller.containerOffsets =
            _controller.containerOffsets.sublist(0, nextListIndex);
      }
    }

    if (sliverListOffset > minScrollOffset &&
        sliverListOffset <= maxScrollOffset) {
      if (_stickyIndex != _listIndex) {
        _stickyIndex = _listIndex;
        _controller.updatePercent(_controller.switchingSectionIndex, 1);
        //update sticky index
        _controller.stickySectionIndex = sectionIndex;
      }
    } else if (sliverListOffset <= 0) {
      _controller.stickySectionIndex = -1;
      _stickyIndex = -1;
    } else {
      _stickyIndex = -1;
    }

    //calc header offset
    double currHeaderOffset = 0;
    double headerMaxOffset = height - header.size.height;
    if (_sticky && isStickyChild && sliverListOffset > minScrollOffset) {
      currHeaderOffset = sliverListOffset - minScrollOffset;
    }
//    print(
//        "index:$listIndex currHeaderOffset:${currHeaderOffset.toStringAsFixed(2)}" +
//            " sliverListOffset:${sliverListOffset.toStringAsFixed(2)}" +
//            " [$minScrollOffset,$maxScrollOffset] size:${content.size.height}");
    positionChild(header, Offset(0, min(currHeaderOffset, headerMaxOffset)));

    //callback header hide percent
    if (currHeaderOffset >= headerMaxOffset && currHeaderOffset <= height) {
      double switchingPercent =
          (currHeaderOffset - headerMaxOffset) / header.size.height;
      _controller.updatePercent(sectionIndex, switchingPercent);
    } else if (sliverListOffset < minScrollOffset + headerMaxOffset &&
        _controller.switchingSectionIndex == sectionIndex) {
      //ensure callback 0% percent.
      _controller.updatePercent(sectionIndex, 0);
      //reset switchingSectionIndex
      _controller.updatePercent(-1, 1);
    }
  }

  bool get isStickyChild => _listIndex == _stickyIndex;

  int get sectionIndex => separated ? _listIndex ~/ 2 : _listIndex;

  double _getSliverListVisibleScrollOffset() {
    return _renderSliver.constraints.overlap +
        _renderSliver.constraints.scrollOffset;
  }

  void _refreshContainerLayoutOffsets() {
    _renderSliver.visitChildren((renderObject) {
      var containerParentData =
          renderObject.parentData as SliverMultiBoxAdaptorParentData;
//      print("visitChildren $containerParentData");

      while (
          _controller.containerOffsets.length <= containerParentData.index!) {
        _controller.containerOffsets.add(0);
      }
      if (containerParentData.layoutOffset != null) {
        _controller.containerOffsets[containerParentData.index!] =
            containerParentData.layoutOffset;
      }
    });
  }

  void positionChild(RenderBox child, Offset offset) {
    final MultiChildLayoutParentData childParentData =
        child.parentData as MultiChildLayoutParentData;
    childParentData.offset = offset;
  }

  Offset childOffset(RenderBox child) {
    final MultiChildLayoutParentData childParentData =
        child.parentData as MultiChildLayoutParentData;
    return childParentData.offset;
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  void checkRefreshContainerOffset() {
    int length = _controller.containerOffsets.length;
    if (_listIndex >= length ||
        (_listIndex > 0 && _controller.containerOffsets[_listIndex]! <= 0)) {
      _refreshContainerLayoutOffsets();
      return;
    }
    for (int i = 0; i < _listIndex && _listIndex < length - 1; i++) {
      double currOffset = _controller.containerOffsets[i]?.toDouble() ?? 0;
      double nextOffset = _controller.containerOffsets[i + 1]?.toDouble() ?? 0;
      if (currOffset > nextOffset) {
        _refreshContainerLayoutOffsets();
        break;
      }
    }
  }
}
