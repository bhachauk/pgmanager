import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg_manager/config/Responsive.dart';
import 'package:pg_manager/config/fw/cluster.dart';
import 'package:pg_manager/config/fw/node.dart';
import 'package:pg_manager/config/fw/util.dart';
import 'package:pg_manager/config/ui/config/config_bloc.dart';
import 'dart:js' as js;

import 'config/ui/config/config_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Node pub = Node("1", isPub: true);
    // Node sub = Node("2");
    // Cluster cluster = Cluster(pub);
    // cluster.subs.add(sub);
    //
    // // assert (cluster.updateConfig("1", "max_wal_senders", "5").isValid == true);
    // // assert (cluster.updateConfig("2", "max_wal_senders", "5").isValid == false);
    // UpdateResponse response = cluster.updateConfig("2", "max_wal_senders", "5");
    // print(response.isValid);
    // response.errorConfigs.forEach((element) {
    //   print(element.errorMsg);
    // });

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'PgManager',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _expanded = true;
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  Widget getBody() {
    _expanded = Responsive(context).isMobile() ? false : true;
    List items = [
      SideMenuItem(
        title: 'Configuration',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.settings),
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SideMenu(
          style: SideMenuStyle(displayMode: _expanded ? SideMenuDisplayMode.open : SideMenuDisplayMode.compact),
          controller: sideMenu,
          onDisplayModeChanged: (mode) {
            print(mode);
          },
          // List of SideMenuItem to show them on SideMenu
          items: items,
        ),
        Expanded(
          child: PageView(
            controller: pageController,
            children: [
              BlocProvider(create: (context) => ConfigBloc(), child: ConfigPage())
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(widget.title, style: const TextStyle(color: Colors.white70),),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white70), onPressed: () {
          _expanded = !_expanded;
          setState(() {
          });
        },),
        actions: [
          IconButton(
            icon: ColorFiltered(colorFilter: const ColorFilter.matrix(
              <double> [ -0.7,  0,  0,  0, 255 * 0.3,
                  0, -0.7,  0,  0, 255 * 0.3,
                  0,  0, -0.7,  0, 255 * 0.3,
                  0,  0,  0,  1,   0,],),
                child: Container(margin: const EdgeInsets.all(5),
                    child: Image.asset("assets/blogo.jpg"))
            ),
            // icon: Container(color: Colors.black87, padding: EdgeInsets.all(10), child: Icon(Icons.code)),
            onPressed: () => {
              js.context.callMethod('open', ['https://bhachauk.github.io'])
          },)
        ],
      ),
      body: getBody(),
    );
  }
}


