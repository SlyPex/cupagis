import 'dart:convert';

import 'package:cupajis/databox.dart';
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class parameter extends StatefulWidget {
  parameter({Key? key}) : super(key: key);

  @override
  State<parameter> createState() => _parameterState();
}

class _parameterState extends State<parameter> {
  late SharedPreferences prefs;

  TextEditingController _controller = TextEditingController()..text = "30";
  TextEditingController _urlcontroller = TextEditingController();
  var hivedata = Boxes.getdata();

  timer timeleft = timer();

  void initState() {
    super.initState();
    setcontroller();
  }

  Future<void> setcontroller() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("expirationtime") != null)
      _controller.text = prefs.getInt("expirationtime").toString();
    if(prefs.getString("") != null)
    _urlcontroller.text=prefs.getString("").toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: home(),
    );
  }

  Widget home() {
    return Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(10, 22, 0, 22),
        child: Row(
          children: [
            Text(
              'Time needed to clear Hive : ',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 30,
              width: 50,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onSubmitted: (value) async {
                  timeleft.expiron = int.parse(value);
                  prefs = await SharedPreferences.getInstance();
                  prefs.setInt("expirationtime", int.parse(value));
                },
              ),
            )
          ],
        ),
      ),
      TextField(
        controller: _urlcontroller,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "http://server_ip_adress:port",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onSubmitted: (value) async {
                  prefs = await SharedPreferences.getInstance();
                  prefs.setString("url", value);
                },
      ),
      TextButton(
          onPressed: () {
            clearhive();
          },
          child: Text("clear data", style: TextStyle(fontSize: 20)))
    ]);
  }

  void clearhive() {
    hivedata.deleteAll(hivedata.keys);
  }
}

class timer {
  int expiron = 30;
  Future<void> cleartimer(Box<datalist> hivedata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("expirationtime") != null)
      this.expiron = (await prefs.getInt("expirationtime"))!;
    var data = hivedata.values.toList().where((element) =>
        (jsonDecode(element.CaptData)['Date']) ==
        DateFormat('dd/MM/yyyy').format(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day - expiron)));
    data.forEach((element) {
      if (element.id != 0) element.delete();
    });
  }
}
class server{
  String url="http://192.168.1.189:5000";
  void seturl(String url){
    this.url=url;
  }
  String geturl(){
    return this.url;
  }
}