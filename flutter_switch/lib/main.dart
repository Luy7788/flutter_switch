import 'package:flutter/material.dart';
import 'package:flutter_switch/provider_widget.dart';
import 'package:flutter_switch/switch.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  PageController mPageController = PageController(initialPage: 1);
  final List<Widget> pages = [
    Container(
      color: Colors.pinkAccent[100],
    ),
    Container(
      color: Colors.blueAccent[200],
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ProviderWidget<SwitchButtonProvider>(
        model: SwitchButtonProvider(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Center(
                  child: SwitchButton(
                    width: 120,
                    height: 44,
                    controller: mPageController,
                    tabs: ['推荐', '热门'],
                    selectColor: Colors.white,
                    unSelectColor: Colors.grey[300],
                  ),
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
              child: PageView.builder(
                itemCount: 2,
                controller: mPageController,
                onPageChanged: (index) {
                  final SwitchButtonProvider page =
                      Provider.of<SwitchButtonProvider>(context, listen: false);
                  page.changePage(index);
                  print('onPageChanged $index');
                },
                itemBuilder: (BuildContext context, int index) {
                  return pages[index];
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
