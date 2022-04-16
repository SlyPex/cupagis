import 'dart:convert';


import 'package:cupajis/datatypes.dart';
import 'package:cupajis/userinput.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' as rootBundle;

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
    "PANEL_HUMID",
    "PANEL_AZOTE",
    "PANEL_PHOSPHATE",
    "PANEL_INFO",
    "DIVINER"
  ];
  
    String? value;
  late String latiude;
  late String longtitude;
  late String altitude;
  
  

  

  
  void getlocation() async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(),
        // bottomNavigationBar: BottomAppBar(
        // child:
        // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // Expanded(
        // child: MaterialButton(
        // child: Icon(
        // Icons.home_rounded,
        // color: Colors.white,
        // size: 40,
        // ),
        // onPressed: () async {})),
        // VerticalDividerWidget(),
        // Expanded(
        // child: MaterialButton(
        // child: Icon(
        // Icons.save_rounded,
        // color: Colors.white,
        // size: 40,
        // ),
        // onPressed: () async {}))
        // ]),
        // color: Colors.blue,
        // ),
        drawer: NavigationDrawer(),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           //  dropdownmenu(),

            forms(),
            
               submitbutton()
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        )));
  }
Widget buildMenuitem({
  required String text,
  VoidCallback? onClicked}){
    return Container(
      height: 100,
      child:Material(
        color: Colors.transparent,
      child: RotatedBox(
      quarterTurns: 1,
     child: ListTile(      
             title: Text(text),
             onTap: onClicked
              )
              )
              )
              ) ;
}
 // DropdownMenuItem<String> buildMenuitem(String item) =>
   //   DropdownMenuItem(value: item, child: Text(item));
      Widget NavigationDrawer(){
        
        return Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Drawer(
          child:Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            color: Color(0xFF1a2f45),
            child: Column(children: [
              draweritem(),
              
              buildcollapseIcon(context)
            ]),
          ),
          
        )
        );
      }
      Widget draweritem(){
        return Container(
          child: Expanded(
            child:ListView.builder(
            shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
         //   return ListTile(
          //   title: Text(items[index]),
         //    onTap: (){
          //   },
          //    ); 
          final item=items[index];
              return buildMenuitem(text: items[index],
              
              onClicked: (){
                setState(() {
                  value=item;
                });
                Navigator.pop(context);
              }
              );
          }
        ) ,
            ) 
          
        );
        
      }
    /*  Widget dropdownmenu(){
        return Container(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: "Attribut", border: OutlineInputBorder()),
                    value: value,
                    isExpanded: true,
                    items: items.map(buildMenuitem).toList(),
                    
                    onChanged: (value){
                      
                      setState(() {
                      this.value = value;
                      
                    });},
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 22));
      }*/
     
     Widget buildcollapseIcon(BuildContext context){
       final double size=52;
       final icon= Icons.arrow_back_ios;
       return InkWell(
         child :Container(
         width: size,
         height: size,
         child: Icon(icon,color: Colors.white,),
       ),
       onTap: (){
         Navigator.pop(context);
       }
       );
     }
      Widget gpsinput(){
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
      Widget submitbutton(){
        return Container(
                height: 60,
                width: 150,
                child: MaterialButton(
                  onPressed: () async {},
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 42,
                  ),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              );
      }
      Widget forms(){
        return FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data){
            var item = data.data as List<datatype>;
            var count;
  
         var i= item.indexWhere((element) => element.item==value);
          if(i!=-1){
          count=item[i].subitems?.length;
          
            return ListView.builder(
        itemCount: count,
        shrinkWrap: true,
        itemBuilder: (BuildContext context,int index){
        if(item[i].subitems![index].intitule.toString()=='GPS')
        return gpsinput();
        else
          return inputform(item[i].subitems![index].intitule.toString());
       
        });
      
        }
        else{return Container();}
         });
      }
      Future<List<datatype>>ReadJsonData() async{
        final jsondata = await rootBundle.rootBundle.loadString('jsons/data-types.json');
        final list = jsonDecode(jsondata) as List<dynamic>;
       
        return list.map((e) => datatype.fromJson(e)).toList();  

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