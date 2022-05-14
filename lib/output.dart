import 'dart:convert';

import 'package:cupajis/databox.dart';
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class outputpage extends StatefulWidget {
  const outputpage({Key? key}) : super(key: key);

  @override
  State<outputpage> createState() => _outputpageState();
}

class _outputpageState extends State<outputpage> {
  final datas = Boxes.getdata().values.cast<datalist>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
       
        body: ValueListenableBuilder<Box<datalist>>(
          valueListenable: Boxes.getdata().listenable(),
          builder: (context, box, _) {
            return listdata();
          },
        ));
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
                mapdata["Type"],
                maxLines: 4,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(mapdata["Date"]),
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
                onPressed: () async {
                  Navigator.pop(context);
                })),
        // VerticalDividerWidget(),
        Expanded(
            child: MaterialButton(
                child: Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () async {}))
      ]),
      color: Colors.blue,
    );
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

  Widget buildbuttons(BuildContext context, datalist data) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: Text('Delete'),
            icon: Icon(Icons.delete),
            onPressed: () => deletedata(data),
          ),
        )
      ],
    );
  }

  void deletedata(datalist data) {
    data.delete();
  }
}
