import 'package:flutter/material.dart';
import 'package:mob_monitoring/classes/db_devices.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as con;

import 'package:mob_monitoring/classes/db_mob.dart';
import 'package:mob_monitoring/packages/extrainfo.dart';

class DeviceList extends StatefulWidget {
  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {

  List<DB_Devices> deviceslist ;//new List<DB_Devices>();

  getDevices() async {
    var res =await http.get(
        Uri.parse("http://192.168.43.131/MOB_Monitoring_API/Devices/getdeviceswithmob"));
    if(res.statusCode == 200){
      setState(() {
       // print(res.body);
        Iterable list = con.json.decode(res.body);
        //print(list);
        deviceslist = list.map((e) => DB_Devices.fromJson(e)).toList();
        print("Status code is 200& ${deviceslist.length}");
      });
    }
    else {
      setState(() {
        deviceslist = null;
      });
    }
  }

  getmobwithdevice(int mid) async{
    var res = await http.get(Uri.parse('http://192.168.43.132/MOB_Monitoring_API/Devices/getmobwithdevice?mid=$mid'));
    if(res.statusCode == 200) {
        setState(() {
          ExtraInfo.selectedmob = DB_Mob.fromJson(con.jsonDecode(res.body));
        });
        Navigator.pushNamed(context, 'capture');
    }
  }

  Widget listview(){
    return deviceslist==null
        ?
    Center(child: CircularProgressIndicator())
        :
    ListView.builder(
      itemCount: deviceslist.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) => new Column(
        children: [
          ListTile(
            onTap: () {
              getmobwithdevice(deviceslist[i].did);
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                (i + 1).toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              deviceslist[i].dname,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              deviceslist[i].flag.toString(),
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ),
          new Divider(
            height: 15.0,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevices();
  }
  @override
  Widget build(BuildContext context) {
    return listview();
  }
}
