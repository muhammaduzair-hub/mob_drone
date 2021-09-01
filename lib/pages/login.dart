import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:mob_monitoring/classes/db_emp.dart';
import 'package:mob_monitoring/pageviews/homeview.dart';

import 'capture_image.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool passshow = false;
  TextEditingController email_con = new TextEditingController();
  TextEditingController pass_con = new TextEditingController();
  DB_Emp u ;

  input() async
  {
    String email = email_con.text;
    String pass = pass_con.text;

    var url = Uri.parse("http://192.168.43.132/MOB_Monitoring_API/employee/emplogin?email=$email&pass=$pass");
    var res = await http.get(url);
    if(res.statusCode == 200) {
      u = DB_Emp.fromJson(convert.jsonDecode(res.body));
      Navigator.pushNamed(context, 'home');
    }
    else
      print("================================war gaya yara");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,//Color.fromRGBO(250, 250, 250,1) ,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Image(
              image: AssetImage("asset/images/2.png"),
              height: 200,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
              color: Color.fromRGBO(66, 165, 255, 1)
            ),
            //color: Color.fromRGBO(66, 165, 255, 1),
            height: 600,
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                TextField(
                  controller: email_con,
                  style: TextStyle(
                    color: Colors.white,//Color.fromRGBO(66, 165, 255, 1),
                  ),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.white,//Color.fromRGBO(66, 165, 255, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 42,vertical: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.white,//Color.fromRGBO(66, 165, 255, 1),
                          width: 2
                      ),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    prefixIcon: Icon(
                      Icons.email, color: Colors.white,
                      //size: 12,
                    ),
                  ),

                ),
                SizedBox(height: 20,),
                TextField(
                  controller: pass_con,
                  style: TextStyle(
                    color: Colors.white//Color.fromRGBO(66, 165, 255, 1),
                  ),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.white,//Color.fromRGBO(66, 165, 255, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 42,vertical: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.white,//Color.fromRGBO(66, 165, 255, 1),
                          width: 2
                      ),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    prefixIcon: Icon(
                      Icons.admin_panel_settings, color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passshow?Icons.visibility:Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: (){
                        setState(() {
                          passshow = !passshow;
                        });
                      },
                    ),
                  ),
                  obscureText: passshow?false:true,
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        child: Text("Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          primary: Colors.white,
                          onPrimary: Colors.white
                        ),

                        onPressed: (){
                          input();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView(),));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
