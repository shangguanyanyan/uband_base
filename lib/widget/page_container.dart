import 'package:flutter/material.dart';
import 'package:ubandbase/constant/export.dart';
import 'package:ubandbase/export.dart';
import 'package:ubandbase/utils/utils.dart';

class PageContainer extends StatefulWidget {
  /// 标题
  final String _title;

  /// 标题后的actions
  final List<Widget> _actions;

  /// 子节点
  final Widget _child;

  /// 显示顶部导航条
  final bool showAppBar;

  /// 自定义AppBar，若showAppBar为false，则此参数无效
  final PreferredSizeWidget customAppBar;

  /// scaffold的resizeToAvoidBottomInset属性，用来适配软键盘弹出时的展示效果
  final bool resizeToAvoidBottomInset;
  final Color backgroundColor;

  /// 返回键按钮，showAppBar=true且customAppBar=null时有效
  final String leadingIcon;

  /// 点击空白处页面，移除输入框焦点
  final bool clickBlankToBlur;

  /// 路由监听器
  final RouteObserver routeObserver;

  /// 页面进入路由栈时的监听回调
  final VoidCallback onPushCallback;

  /// 页面退出路由栈时的监听回调
  final VoidCallback onPopNextCallback;

  PageContainer(
      {Key key,
      Widget child,
      String title,
      List<Widget> actions,
      this.showAppBar = true,
      this.customAppBar,
      this.resizeToAvoidBottomInset = true,
      this.backgroundColor = const Color(0xffffffff),
      this.leadingIcon,
      this.clickBlankToBlur = false,
      this.routeObserver,
      this.onPushCallback,
      this.onPopNextCallback})
      : _child = child,
        _title = title,
        _actions = actions,
        super(key: key);

  Widget get child => _child;

  String get title => _title;

  List<Widget> get actions => _actions;

  @override
  State<StatefulWidget> createState() {
    return _PageContainerState();
  }
}

class _PageContainerState extends State<PageContainer> with RouteAware {
  /// 处理返回操作
  _handleBack() {
    Navigator.pop(context);
  }

  /// 是否可以返回
  bool get canBack => Navigator.canPop(context);

  _buildAppBar() {
    if (!widget.showAppBar) {
      return null;
    }
    if (widget.customAppBar != null) {
      return widget.customAppBar;
    }

    return AppBar(
      title: widget.title != null
          ? Quick.buildText(widget.title, fontSize: 17).bold().build()
          : null,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: canBack
          ? IconButton(
              onPressed: _handleBack,
              color: Colors.black87,
              icon: Icon(Icons.chevron_left, size: Adapt.px(30)),
            )
          : null,
      actions: widget.actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    var current = widget.child;
    // wrap child here.

    current = Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: null,
      bottomNavigationBar: null,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      backgroundColor: widget.backgroundColor,
      body: current,
    );

    // wrap scaffold here
    if (widget.clickBlankToBlur) {
      current = GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: current,
      );
    }

    return current;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver?.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    widget.routeObserver?.unsubscribe(this);
    super.dispose();
  }

  /// 当前页面被放入路由栈
  @override
  void didPush() {
    widget.onPushCallback?.call();
  }

  /// 当前页面弹出路由栈
  @override
  void didPopNext() {
    widget.onPopNextCallback?.call();
  }
}
