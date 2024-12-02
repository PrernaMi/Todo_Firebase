import 'package:flutter/material.dart';
import 'package:todo_firebase/screens/home_page.dart';

import '../app_const/color_const.dart';

class InitialScreen extends StatefulWidget {
  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen>
    with SingleTickerProviderStateMixin {
  TabController? mController;

  @override
  void initState() {
    mController = TabController(length: 2, vsync: this);
    mController!.index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Task Tracker",
              style: TextStyle(
                  fontFamily: 'AppBar',
                  color: ColorConst().mColor[0],
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              "assets/icons/todo_ic.png",
              width: 40,
            )
          ],
        ),
        centerTitle: true,
        bottom: TabBar(controller: mController, tabs: [
          Tab(
            child: Text("Open"),
          ),
          Tab(
            child: Text("Completed"),
          )
        ]),
      ),
      body: TabBarView(controller: mController, children: [
        HomePage(
          pageView: "Open",
        ),
        HomePage(pageView: "Complete")
      ]),
    );
  }
}
