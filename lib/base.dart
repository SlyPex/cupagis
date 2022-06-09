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
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: GestureDetector(
            onTap: () {
              logout();
            },
             child: Icon(
          Icons.logout_outlined,
          size: 26.0,
        ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: GestureDetector(
            onTap: () {
              checklogin();
            },
             child: Icon(
          Icons.check,
          size: 26.0,
        ),
          ),
        )
      ]),
    // drawer:NavigationDrawer(),
      bottomNavigationBar: NavigationBar(),
      body://pages[_selecteditem] 
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

    Widget NavigationDrawer() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Drawer(
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            color: Color(0xFF1a2f45),
            child: Column(children: [draweritem(), buildcollapseIcon(context)]),
          ),
        ));
  }

   Widget buildMenuitem({required String text, VoidCallback? onClicked}) {
    return Container(
        height: 100,
        child: Material(
            color: Colors.transparent,
            child: RotatedBox(
                quarterTurns: 1,
                child: ListTile(title: Text(text),textColor: Colors.white, onTap: onClicked,))));
  }

  Widget draweritem() {
    return Container(
        child: Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return  buildMenuitem(
                text: items[index],
                onClicked: () {
                  //Textcontroller.clear();
                  //locationalt.clear();
                  //locationlat.clear();
                  //locationlong.clear();
                  setState(() {
                    value = items[index];
                  });
                  Navigator.pop(context);
                });
          }),
    ));
  }

Widget buildcollapseIcon(BuildContext context) {
    final double size = 52;
    final icon = Icons.arrow_back_ios;
    return InkWell(
        child: Container(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        });
  }

  void logout() async{
    http.Response response= await Session().logout();
    print(response.body);
    print(response.headers);
  }
  void checklogin() async{
   final response=await Session().checklogin();
    print(response.body);
  }
  String url="http://192.168.43.149:5000";
  void senddatatoserver()async{
   var data=datas.toList().where((element) => element.id==0);
   for(var i in data){
     http.Response response=await Session().post(url,jsonEncode({"data":jsonDecode(i.CaptData)}));
    print(response.body);
    http.Response getresponse=await Session().get(url);
    var id=jsonDecode(getresponse.body)['id'];
    i.id=id;

   }
    
  }
}