import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ubandbase/constant/constant.dart';
import 'package:ubandbase/export.dart';
import 'package:ubandbase/utils/utils.dart';

import 'my_paint.dart';


void main() {
  Adapt.init(designWidth: 375);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController tabController;

  _buildTabBar(TabController controller) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      indicator: TabIndicator(
          borderSide: BorderSide(
              width: Adapt.px(2), color: ColorUtil.hex(BaseColour.thunder)),
          shapeType: ShapeType.curve,
          radius: Adapt.px(5),
          wantWidth: Adapt.px(30)),
      labelPadding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      labelColor: ColorUtil.hex(BaseColour.thunder),
      labelStyle:
          TextStyle(fontSize: Adapt.fontPx(14), fontWeight: FontWeight.bold),
      unselectedLabelColor: ColorUtil.hex(BaseColour.thunder, alpha: 0.35),
      unselectedLabelStyle: TextStyle(fontSize: Adapt.fontPx(14)),
      tabs: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(15),
          ),
          child: Text("page one"),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(15),
          ),
          child: Text('page two'),
        )
      ],
    );
  }

  _buildTabView(TabController controller) {
    return TabBarView(
      controller: controller,
      children: <Widget>[
        Center(
          child: CustomPaint(
            size: Size(300,300),
            painter: MyPaint(),
          ),
        ),
        Center(
          child: Quick.buildText("page two").build(),
        ),
      ],
    );
  }


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      showAppBar: true,
      title: "我是标题",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTabBar(tabController),
          Expanded(
            child: _buildTabView(tabController),
          )
        ],
      ),
    );
  }
}
