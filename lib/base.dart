import 'dart:convert';
import 'package:cupajis/httpservice.dart';
import 'package:cupajis/databox.dart';
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:flutter/material.dart';
import 'package:cupajis/input.dart';
import 'package:cupajis/output.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Base extends StatefulWidget {
  const Base({ Key? key }) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  var datas=Boxes.getdata().values.cast<datalist>();
  bool hasConnection=false;
  var pages=[Input(),outputpage(key: UniqueKey(),)];
int _selecteditem=0;
final items = [
    "Humidité",
    "Azote",
    "Phosphate",
    "Information Libre",
    "Humidité Diviner",
    "Indice de végétation NDVI",
    "Radio Spectromètre",
    "Capteur NPK",
    "Capteur Conductivité Eléctrique"
  ];
String? value;
@override
void initState(){
  super.initState();
  InternetConnectionChecker().onStatusChange.listen((status) {
    final hasconnection=status==InternetConnectionStatus.connected;
    setState(() {
      this.hasConnection=hasconnection;
    });
    if(hasConnection){
      senddatatoserver();
    }
    
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      bottomNavigationBar: NavigationBar(),
      body:
      IndexedStack(children: pages,index: _selecteditem),
      
    );
  }

   Widget NavigationBar() {
    return BottomNavigationBar(
      items: [BottomNavigationBarItem(
        icon: Icon(Icons.library_add_rounded, size: 40,),
        label: 'home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted_rounded, size: 40,),
          label: 'save' 
        )],
        currentIndex: _selecteditem,
        onTap: (index){
          setState(() {
            _selecteditem=index;
          });
        },
      );
    
   
  }

  String url="http://192.168.43.149:5000";
  void senddatatoserver()async{
   var data=datas.toList().where((element) => element.id==0);
   for(var i in data){
     http.Response response=await Session().post(url,jsonEncode({"data":jsonDecode(i.CaptData)}));
    print(response.body);
   var id=response.headers['id'];
    i.id=int.parse(id!);
    i.save();
   }
    
  }
}