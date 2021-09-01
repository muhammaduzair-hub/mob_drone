import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as con;

import 'package:mob_monitoring/classes/db_mob.dart';

class CaptureImage extends StatefulWidget {

  final DB_Mob selectmob;
  const CaptureImage({Key key, this.selectmob}) : super(key: key);

  @override
  _CaptureImageState createState() => _CaptureImageState(selectmob);
}

class _CaptureImageState extends State<CaptureImage> {

  final DB_Mob selectmob;
  _CaptureImageState(this.selectmob);


  final DateFormat dateFormat =DateFormat('yyyy-MM-dd HH:mm');
  double long,lat;
  DateTime dateTime = DateTime.now();
  String pname,padress;


  Completer<GoogleMapController> mapController = Completer();
  static const LatLng center = const LatLng(33.6844, 73.0479);
  final Set<Marker> marker = {};
  LatLng lastMapPosition = center;
  MapType currentMapType = MapType.normal;

  static final CameraPosition position = CameraPosition(
    bearing: 192.833,
    target: LatLng(33.6844, 73.0479),
    tilt: 59.440,
    zoom: 11.0
  );




  Future<void> goToPositone1() async{
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  onMapCreated(GoogleMapController controller){
    mapController.complete(controller);
  }

  onCameraMove(CameraPosition position){
    lastMapPosition = position.target;
  }

  onMapTypeButtonPressed(){
    setState(() {
      currentMapType = currentMapType == MapType.normal? MapType.satellite: MapType.normal;
    });
  }

  Widget button (Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize:  MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0,),
      );
  }

  onAddMarkerButtonPressed(){
    setState(() {
      marker.add(
        Marker(
          markerId: MarkerId(lastMapPosition.toString()),
          position: lastMapPosition,
          infoWindow: InfoWindow(
            title:'',
            snippet: '',
          ),
          icon: BitmapDescriptor.defaultMarker,
        )
      );
    });
  }

  MyMarker(double long, double lat){
    setState(() {
      marker.add(
        Marker(
          markerId: MarkerId('Presses Marker'),
          position: LatLng(lat,long),
          infoWindow: InfoWindow(
            title: 'marker',
          ),
          icon: BitmapDescriptor.defaultMarker
        )
      );
    });
  }

  File _image;
  final picker = ImagePicker();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        var byte = File(_image.path).readAsBytesSync();
        setState(() {
          padress = con.base64Encode(byte);
          pname = _image.path.split('/').last;
          //print('${padress}');
        });
      }
    });
    //showToast(padress.substring(1,20));
  }

  showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  SendPicture() async {
    print("In SendPicture");
    print(pname+"\n"+lat.toString()+"\n"+long.toString()+"\n"+dateTime.toString()+'\n${selectmob.mid}\n${padress}');
    var Url = Uri.parse('http://192.168.43.131/MOB_Monitoring_API/Picture/PostPicture');
    var res = await http.post(
        Url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body:con.jsonEncode(<String, dynamic> {
          'Pname':pname,
          'Paddress':padress,
          'Platitude':lat==null?null:lat,
          'Plongitude':long==null?null:long,
          'Ptime':dateTime.toString(),
          "mid": selectmob.mid,
        })
    );
    if(res.statusCode == 200) {
        showToast(res.body.toString());
        print(res.body);
    }
    else {
      print(res.body);
      showToast(res.body);
    }
    if(res==null)
      showToast("No response");
  }


  disposemob() async{
    int mid = selectmob.mid;
    var res = await http.put(Uri.parse('http://192.168.43.131/MOB_Monitoring_API/Mob/DisposeMob?mid=$mid'));
    if(res.statusCode == 200) {
      showToast("Mob Is End");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("MOB Monitoring"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white, size: 20,),
          onPressed: ()=>showDialog(
              context: context,
              builder: (_)=> AlertDialog(
                title: Text("MOB End", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                content: Text("Is Mob end?", style: TextStyle(fontSize: 16, color: Colors.white)),
                backgroundColor: Colors.blue,
                elevation: 2.0,
                buttonPadding: EdgeInsets.symmetric(horizontal: 15),
                //shape: CircleBorder(),
                actions: [
                  ElevatedButton(
                    child: Text('Yes', style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: (){
                      Navigator.of(context).pop();
                      disposemob();
                    },
                  ),
                  ElevatedButton(
                    child: Text('No', style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            barrierDismissible: false,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (LatLng){
              setState(() {
                long = LatLng.longitude;
                lat = LatLng.latitude;
                MyMarker(long, lat);
              });
            },
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 11.0
            ),
            mapType: currentMapType,
            markers: marker,
            onCameraMove: onCameraMove,
          ),
          Align(
            alignment: Alignment.topCenter,
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        getImage();
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.blue,
                        backgroundImage: _image==null?
                          AssetImage('asset/images/person-male.png'):
                          FileImage(_image),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue
                            ),
                            child:IconButton(
                              icon:Icon(Icons.minimize, color: Colors.white,) ,
                              onPressed: (){
                                setState(() {
                                  dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute-1);
                                });
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          GestureDetector(
                            onTap: () async {
                              DateTime dates = DateTime.now();
                              TimeOfDay time = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              ).then((data){
                                dates = data;}
                              );

                              time = await showTimePicker(context: context,
                                  initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));

                              setState(() {
                                dateTime = DateTime(dates.year, dates.month, dates.day, time.hour, time.minute);
                              });

                            },
                            child: Container(

                              width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.blue
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                                child: Row(
                                    children:[
                                      Text('Date: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      Text(dateFormat.format(dateTime), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ]
                                ),
                              ),

                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Container(
                            width: 40,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue
                            ),
                            child:IconButton(
                              icon:Icon(Icons.add, color: Colors.white,) ,
                              onPressed: (){
                                setState(() {
                                  dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute+1);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 370,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Container(
                        width: 230,
                        child: ElevatedButton(
                            onPressed: (){
                              SendPicture();
                              },
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.blue,
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text("Send",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                        ),
                      ),
                    )
                  ],
                ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  SizedBox(height: 500,),
                  button(onMapTypeButtonPressed, Icons.map),
                  // SizedBox(height: 16,) ,
                  // button(onAddMarkerButtonPressed, Icons.add_location),
                  SizedBox(height: 16,),
                  button(goToPositone1, Icons.location_searching),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
