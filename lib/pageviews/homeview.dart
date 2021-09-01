import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mob_monitoring/pageviews/devicelist.dart';
import 'package:mob_monitoring/pageviews/moblist.dart';
import 'package:mob_monitoring/classes/db_mob.dart';



class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin{

  TabController _listcontroller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listcontroller = new TabController(length: 2, vsync:this,  initialIndex: 0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 20, color: Colors.white,),
            onPressed: (){},
          ),
        ],
        centerTitle: true,
        title: Text("Home"),
        bottom: new TabBar(
          controller: _listcontroller,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: FaIcon(FontAwesomeIcons.peopleCarry),
              text: 'Mobs',
            ),
            Tab(
              icon: Icon(Icons.devices),
              text: 'Devices',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _listcontroller,
        children: [
          new MobList(),
          new DeviceList()
        ],
      ),
    );
  }
}
