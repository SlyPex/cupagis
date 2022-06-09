import 'dart:convert';
import 'package:cupajis/datatypes.dart';
import 'package:intl/intl.dart';
import 'package:cupajis/output.dart';
import 'package:cupajis/userinput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cupajis/databox.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cupajis/httpservice.dart';
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart' as rootBundle;


class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);
  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  TextEditingController locationlat = TextEditingController();
  TextEditingController locationlong = TextEditingController();
  TextEditingController locationalt = TextEditingController();
  var Textcontroller = [];
 
 DateTime dateTime=DateTime.now();
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
  List<datatype> item = [];
 bool hasinternet=false;
  String? value;
  late String latiude;
  late String longtitude;
  late String altitude;
  void getlocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    var lat = position.latitude;
    var long = position.longitude;
    var alt = position.altitude;
    latiude = '$lat';
    longtitude = '$long';
    altitude = '$alt';
    setState(() {
      locationlat.text = latiude;
      locationlong.text = longtitude;
      locationalt.text = altitude;
    });
  }

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        
       // bottomNavigationBar: BottomNavigationBar(),
        drawer: NavigationDrawer(),
        body: SingleChildScrollView(
          child:
            Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [forms(), submitbutton()],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        )
        )
        );
  }

  Widget BottomNavigationBar() {
    return BottomAppBar(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
            child: MaterialButton(
                child: Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () async {})),
        // VerticalDividerWidget(),
        Expanded(
            child: MaterialButton(
                child: Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const outputpage()));
                }))
      ]),
      color: Colors.blue,
    );
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
                  Textcontroller.clear();
                  locationalt.clear();
                  locationlat.clear();
                  locationlong.clear();
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

  Widget gpsinput() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextField(
                  controller: locationlat,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "X :", border: OutlineInputBorder()),
                ),
                width: 100,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextField(
                  controller: locationlong,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Y :", border: OutlineInputBorder()),
                ),
                width: 100,
              ),
              Container(
                child: TextField(
                  controller: locationalt,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Z :", border: OutlineInputBorder()),
                ),
                width: 100,
              )
            ],
          ),
          Container(
            width: 70,
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                getlocation();
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: const Icon(
                Icons.add_location_alt_outlined,
                size: 24,
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.fromLTRB(0, 22, 0, 22),
    );
  }

  Widget submitbutton() {
    return Container(
      height: 60,
      width: 150,
      child: MaterialButton(
        onPressed: () async {
          /*for (var i = 0; i < Textcontroller.length; i++) {
            print(Textcontroller[i].text);
          }*/
          putdata();
          
          
          //showtoast();
        },
        color: Colors.blue,
        textColor: Color.fromARGB(255, 8, 7, 7),
        child: const Icon(
          Icons.add,
          size: 42,
        ),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

Widget dateinput(){
  return Container(
     decoration: BoxDecoration(
       border:  Border.all(color: Color(0xFF7F7F7F)),
      borderRadius: BorderRadius.all(Radius.circular(10))
     ),
    height: 100,
  child:CupertinoDatePicker(
    minimumYear: 2015,
    maximumYear: DateTime.now().year,
    initialDateTime: dateTime,
    mode: CupertinoDatePickerMode.date,
    onDateTimeChanged: (dateTime)=>
  setState((() => this.dateTime=dateTime))
    )
    );
}

  Widget forms() {
    return FutureBuilder(
        future:  ReadJsonData(),
        builder: (context, data) {
          item = data.data as List<datatype>;
          var count;
          var i = item.indexWhere((element) => element.intitule == value);
          if (i != -1) {
            count = item[i].subitems?.length;
            setcontrollers(count);
            return ListView.builder(
              primary: false,
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (item[i].subitems![index].uiType == UiType.GPS)
                    return gpsinput();
                  else {
                    if(item[i].subitems![index].uiType==UiType.DATE)
                    return dateinput();
                    else{
                      if(item[i].subitems![index].uiType==UiType.TEXT)
                      return inputform(
                        item[i].subitems![index].intitule.toString(),
                        Textcontroller[index],
                        TextInputType.text);
                        else
                        return inputform(
                        item[i].subitems![index].intitule.toString(),
                        Textcontroller[index],
                        TextInputType.number);
                    }
                    
                  }
                });
          } else {
            return Container();
          }
        });
  }

  Future<List<datatype>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('jsons/data-types.json');
    final list = jsonDecode(jsondata) as List<dynamic>;

    return list.map((e) => datatype.fromJson(e)).toList();
  }

  void setcontrollers(int count) {
    for (var i = 0; i < count; i++) {
      Textcontroller.add(TextEditingController());
    }
  }


  Future<void> putdata() async {
    final datevalue= DateFormat('dd/MM/yyyy').format(dateTime);
    var j = item.indexWhere((element) => element.intitule == value);
    Map<String, dynamic> json = {
      "Type": value,
    };
    for (var i = 0; i < item[j].subitems!.length; i++) {
      if (item[j].subitems![i].intitule == 'GPS') {
        json['GPS'] = {
          'LAT': locationlat.text,
          'LONG': locationlong.text,
          'ALT': locationalt.text
        };
      } else {
        if(item[j].subitems![i].intitule=='Date'){
        json['Date']=datevalue;}
        else{
        json[item[j].subitems![i].intitule.toString()] = Textcontroller[i].text;
        }
      }
      
    }
    
   
    hasinternet = await InternetConnectionChecker().hasConnection;
    if(hasinternet){
      print('has connection');
      senddatatoserver(json);
    }else{
      final data = datalist()
   ..CaptData =jsonEncode(json)
   ..id=0;
   final box =Boxes.getdata();
   
   showtoast("saved locally");
    }
    setState(() {
          Textcontroller.clear();
          locationalt.clear();
          locationlat.clear();
          locationlong.clear();  
          });
  }
  
  


String url="http://192.168.43.149:5000";
  Future<void> senddatatoserver(Map<String, dynamic> json) async{
   var response= await Session().post(url,jsonEncode({"data":json}));
    showtoast(response.body.toString());
  }  
  
  void showtoast(String msg)=>Fluttertoast.showToast(
    msg: msg,
    fontSize: 16,
    );
  
}