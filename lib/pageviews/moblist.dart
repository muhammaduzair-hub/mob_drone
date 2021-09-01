import 'package:flutter/material.dart';
import 'package:mob_monitoring/classes/db_mob.dart';
import 'package:mob_monitoring/packages/extrainfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as con;

class MobList extends StatefulWidget {
  @override
  _MobListState createState() => _MobListState();
}

class _MobListState extends State<MobList> {

  List<DB_Mob> moblist;
  getmob() async {
    var response =await http.get(Uri.parse('http://192.168.43.131/MOB_Monitoring_API/Mob/getactive'));
    if(response.statusCode == 200)
    {
      setState(() {
        Iterable list = con.json.decode(response.body);
        moblist = list.map((e) => DB_Mob.fromJson(e)).toList();
      });
    }
    else
    {
      setState(() {
        moblist= null;
      });
    }
  }

  Widget listview(){
    return ListView.builder(
      itemCount: moblist.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) =>Column(
        children: [
          ListTile(
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
                moblist[i].mname,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  ExtraInfo.selectedmob = moblist[i];
                });
                Navigator.pushNamed(context, 'capture');
              }
          ),

          Divider(
            color: Colors.blue,
            height: 15,
          ),
        ],
      ) ,
    );
  }

  @override
  void initState() {
    getmob();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return moblist == null?Center(child: CircularProgressIndicator()):listview();
  }
}
