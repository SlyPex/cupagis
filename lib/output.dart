import 'dart:convert';
import 'package:cupajis/databox.dart';
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class outputpage extends StatefulWidget {
  const outputpage({Key? key}) : super(key: key);

  @override
  State<outputpage> createState() => _outputpageState();
}

class _outputpageState extends State<outputpage> {
  var datas =Boxes.getdata().values.cast<datalist>();
  var keys=Boxes.getdata().keys.cast<int>();
  String url="http://192.168.43.149:5000";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          actions: [
            Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          getdatafromserver();
        },
        child: Icon(
          Icons.refresh,
          size: 26.0,
        ),
      )
    ),
          ],
        ),
        body: //Column(
        // children: [
           ValueListenableBuilder<Box<datalist>>(
             valueListenable: Boxes.getdata().listenable(),
             builder: (context, box, _) {
               return listdata();
             },
           ),
          // Text(thisdata.toString()),
            //TextButton(onPressed: () async{
             
             //final response= await http.get(Uri.parse('https://192.168.43.149:5000'));
            // var maindata=response.toString();
           
            //senddatatoserver();
            //getdatafromserver();
            //print("data sended");

  
          // }, child: Text('getdata'),)
        //  ],
        //)
        );
  }

  Widget listdata() {
    return ListView.builder(
        itemCount: datas.length,
        itemBuilder: (BuildContext context, index) {
          final data = datas.toList()[index];
          Map<String, dynamic> mapdata = jsonDecode(data.CaptData);
          return Card(
            color: Colors.white,
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              title: Text(
                //jsonDecode(datas.toList()[index].CaptData) ,
                data.id.toString()+': '+mapdata["Type"].toString(),
                maxLines: 4,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(mapdata["Date"].toString()),
              trailing: mapdata.containsKey(mapdata['Type'])? Text(
                mapdata[mapdata['Type']].toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ):null,
              children: [
                //Text((mapdata.keys+": ")+mapdata.values.toList().iterator.toString()),
                mapdata.containsKey('GPS')
                    ? Text(mapdata['GPS']['LAT'] +
                        " " +
                        mapdata['GPS']['LONG'] +
                        " " +
                        mapdata['GPS']['ALT'])
                    : Container(),

                for (var i = 1;
                    i < mapdata.keys.toList().indexWhere((element) => element == 'Date');
                    i++)
                  Text(mapdata.keys.toList()[i].toString() +
                      ': ' +
                      mapdata.values.toList()[i].toString()),
                buildbuttons(context, data)
                // buildButtons(context, transaction),
              ],
            ),
          );
        });
  }



  Widget button() {
    return MaterialButton(
      onPressed: (() {
        deletedata(datas.toList()[3]);
      }),
      color: Colors.blue,
      textColor: Color.fromARGB(255, 8, 7, 7),
      child: const Icon(
        Icons.add,
        size: 42,
      ),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

Future<void> getdatafromserver() async {
  final response= await http.get(Uri.parse(url));
  var serverdata=jsonDecode(response.body) as List;
    
    for (var i = 0; i < serverdata.length; i++) {
      
      final data=datalist()
      ..CaptData=jsonEncode(serverdata[i]['data'])
      ..id=serverdata[i]['id'];
      final box=Boxes.getdata();
      box.add(data);
    }
  
}


  Widget buildbuttons(BuildContext context, datalist data) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: Text('Delete'),
            icon: Icon(Icons.delete),
            onPressed: () => showdialog(data),
          ),
        )
      ],
    );
  }

  Future showdialog(datalist data){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("do you want to delete this item"),
          actions: [
            
             TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("CANCEL")),
TextButton(onPressed: (){
              deletedata(data);
              Navigator.pop(context);
            }, child: Text("DELETE")),
          ],
        );
      }
    );
  }

  void deletedata(datalist data) {
    data.delete();
  }
}
