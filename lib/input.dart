import 'dart:convert';
import 'package:cupajis/datatypes.dart';
import 'package:cupajis/pages/SignIn.dart';
import 'package:cupajis/parameters.dart';
import 'package:intl/intl.dart';
import 'package:cupajis/userinput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cupajis/databox.dart';
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
    "Humidity",
    "Nitrogen",
    "Phosphate",
    "Free Information",
    "Humidity Diviner",
    "Vegetation index NDVI",
    "Radio Spectrometer",
    "NPK Sensor",
    "Electronic Conductivity Sensor"
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>parameter()));
            },
             child: Icon(
          Icons.settings,
          size: 26.0,
        ),
          ),
        ),
        ]),
        drawer: NavigationDrawer(),
        body: SingleChildScrollView(
          child:
            Center(
              child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [forms(), submitbutton()],
          ),
          margin:  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
            )
        )
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
          putdata();  
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
    return  FutureBuilder(
        future:  ReadJsonData(),
        builder: (context, data)  {
          if(!data.hasData)
          {return SizedBox();};
          item =  data.data as List<datatype>;
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
                    return SizedBox();
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

    return  list.map((e) => datatype.fromJson(e)).toList();
  }

  void setcontrollers(int count) {
    for (var i = 0; i < count; i++) {
      Textcontroller.add(TextEditingController());
    }
  }


  Future<void> putdata() async {
    final datevalue= DateFormat('dd/MM/yyyy').format(DateTime.now());
    var j = item.indexWhere((element) => element.intitule == value);
    Map<String, dynamic> json = {
      "Type": value,
    };
    for (var i = 0; i < item[j].subitems!.length; i++) {
      if (item[j].subitems![i].intitule == 'GPS') {
        json['GPS'] = {
          'LAT': double.parse(locationlat.text),
          'LONG': double.parse(locationlong.text),
          'ALT': double.parse(locationalt.text)
        };
      } else {
        if(item[j].subitems![i].intitule=='Date'){
        json['Date']=datevalue;}
        else{
          if(item[j].subitems![i].uiType==UiType.REAL)
        json[item[j].subitems![i].intitule.toString()] = double.parse(Textcontroller[i].text);
        else json[item[j].subitems![i].intitule.toString()] = Textcontroller[i].text;
        }
      }
      
    }
    
   final data = datalist()
   ..CaptData =jsonEncode(json)
   ..id=0;
   final box =Boxes.getdata();
     var response= await Session().post("/",jsonEncode({"data":json}));
     if(response["success"]){
    showtoast(response["result"].body.toString());
    data.id=int.parse(response['result'].headers['id'].toString()) ;
    }else{
   showtoast("saved locally");
    }
    box.add(data);
    setState(() {
          Textcontroller.clear();
          locationalt.clear();
          locationlat.clear();
          locationlong.clear();  
          });
  }
    
  
  void showtoast(String msg)=>Fluttertoast.showToast(
    msg: msg,
    fontSize: 16,
    );
   void logout() async{
    var response= await Session().logout();
    if(response.statusCode==200)
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLogin()));
  }
}