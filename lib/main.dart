import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
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
  final items = [
    "Humidité",
    "Phosphore",
    "Kolt",
    "Or",
    "Argent",
  ];
  String? value;
  late String latiude;
  late String longtitude;
  late String altitude;
  void getlocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    var alt = position.altitude;
    latiude = '$lat';
    longtitude = '$long';
    altitude = '$alt';
    print(latiude);
    print(longtitude);
    setState(() {
      locationlat.text = latiude;
      locationlong.text = longtitude;
      locationalt.text = altitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
                labelText: "Attribut", border: OutlineInputBorder()),
            value: value,
            isExpanded: true,
            items: items.map(buildMenuitem).toList(),
            onChanged: (value) => setState(() => this.value = value),
          ),
          const TextField(
            decoration: InputDecoration(
                labelText: "Value", border: OutlineInputBorder()),
            toolbarOptions: ToolbarOptions(
                copy: true, cut: true, paste: false, selectAll: true),
            keyboardType: TextInputType.number,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: TextField(
                  controller: locationlat,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "X :", border: OutlineInputBorder()),
                ),
                width: 60,
              ),
              Container(
                child: TextField(
                  controller: locationlong,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Y :", border: OutlineInputBorder()),
                ),
                width: 60,
              ),
              Container(
                child: TextField(
                  controller: locationalt,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Z :", border: OutlineInputBorder()),
                ),
                width: 60,
              ),
              Container(
                width: 50,
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
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
    ));
  }

  DropdownMenuItem<String> buildMenuitem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}
