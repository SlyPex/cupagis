import 'dart:convert';
import 'package:cupajis/datatypes.dart';
import 'package:intl/intl.dart';
import 'package:cupajis/output.dart';
import 'package:cupajis/userinput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cupajis/databox.dart';
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart' as rootBundle;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(datalistAdapter());
  await Hive.openBox<datalist>('datas');
  runApp(
    const MaterialApp(
      title: 'Cupajis',
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController locationlat = TextEditingController();
  TextEditingController locationlong = TextEditingController();
  TextEditingController locationalt = TextEditingController();
  var Textcontroller = [];
 int id=0;
 DateTime dateTime=DateTime.now();
  final items = [
    "Humidité",
    "Azote",
    "Phosphate",
    "Information Libre",
    "Humidité Diviner"
  ];
  List<datatype> item = [];
var hello;
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
        appBar: AppBar(),
        bottomNavigationBar: BottomNavigationBar(),
        drawer: NavigationDrawer(),
        body: SingleChildScrollView(
            child: Container(
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
                child: ListTile(title: Text(text), onTap: onClicked))));
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
            //   return ListTile(
            //   title: Text(items[index]),
            //    onTap: (){
            //   },
            //    );
            //final item = items[index];
            return buildMenuitem(
                text: items[index],
                onClicked: () {
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
  
  return SizedBox( 
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
        future: ReadJsonData(),
        builder: (context, data) {
          item = data.data as List<datatype>;
          var count;
          Textcontroller.clear();
          var i = item.indexWhere((element) => element.intitule == value);
          if (i != -1) {
            count = item[i].subitems?.length;

            setcontrollers(count);
            return ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (item[i].subitems![index].intitule.toString() == 'GPS')
                    return gpsinput();
                  else {
                    if(item[i].subitems![index].intitule.toString()=='Date')
                    return dateinput();
                    else
                    return inputform(
                        item[i].subitems![index].intitule.toString(),
                        Textcontroller[index]);
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

   @override
  void dispose() {
    Hive.close();
    super.dispose();
    // dispose textEditingControllers to prevent memory leaks
    for (TextEditingController textEditingController in Textcontroller) {
      textEditingController.dispose();
    }
  }
  void putdata() {
    final datevalue= DateFormat('dd/MM/yyyy').format(dateTime);
    id=id+1;
    var j = item.indexWhere((element) => element.intitule == value);
    Map<String, dynamic> json = {
      "Type": value,
    };
    for (var i = 0; i < item[j].subitems!.length; i++) {
      if (item[j].subitems![i].intitule == 'GPS') {
        json['GPS'] = {
          'LAT': locationlat.text,
          'LONG': locationlong.text,
          'LAL': locationalt.text
        };
      } else {
        if(item[j].subitems![i].intitule=='Date'){
        json['Date']=datevalue;}
        else{
        json[item[j].subitems![i].intitule.toString()] = Textcontroller[i].text;
        }
      }
    }
    
    final data = datalist()
    ..CaptData =jsonEncode(json)
    ..id=id;
    final box =Boxes.getdata();
    box.add(data);
  }
 
}

// class VerticalDividerWidget extends StatelessWidget {
// @override
// Widget build(BuildContext context) {
// return Container(
// height: 48,
// width: 2,
// color: Colors.white,
// );
// }
// }
