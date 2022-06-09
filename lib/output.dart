import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'httpservice.dart';
import 'databox.dart';
import 'hivemodel/datalist.dart';

class outputpage extends StatefulWidget {
  const outputpage({Key? key}) : super(key: key);

  @override
  State<outputpage> createState() => _outputpageState();
}

class _outputpageState extends State<outputpage> {
  var datas =Boxes.getdata().values.toList().where((element) => element.id==0).cast<datalist>();
  //var keys=Boxes.getdata().keys.cast<int>();
  List serverdata=[];
  final ValueNotifier datanotifier=ValueNotifier([]);
  String url="http://192.168.43.149:5000";
  @override
  void initState(){
    super.initState();
  // for(var i in datas){
  //  hivedata.addAll(jsonDecode(i.CaptData)); 
  // }
    
     //getdatafromserver();
  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    getdatafromserver();
    datanotifier.value=datas;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       /* appBar:  AppBar(
          actions: [
            Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
        //var data=Boxes.getdata();
        //data.clear();
          getdatafromserver();  
        },
        child: Icon(
          Icons.refresh,
          size: 26.0,
        ),
      )
    ),
    Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
       // var data=Boxes.getdata();
       // data.clear();
       //     
        },
        child: Icon(
          Icons.delete,
          size: 26.0,
        ),
      )
    ),
          ],
        ),*/
        body: //Column(
        // children: [
           
           ValueListenableBuilder(
               valueListenable:  datanotifier,
               builder: (context, box, _) {
                 return listdata();
               },
             ),
           
        );
  }

  Widget listdata() {
    return ListView.builder(
       // reverse: true,
          itemCount: serverdata.length+datas.length,
          itemBuilder: (BuildContext context, index) {
            Map data={};
              if(index<serverdata.length){
                data= serverdata[index]['data'];
              }else{
                data=jsonDecode(datas.toList()[index-serverdata.length].CaptData);
               
              }
           // print(datas.values.toList()[index]);
            final id=serverdata[index]['id'];
            return Card(
              color: Colors.white,
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title: Text(
                  //jsonDecode(datas.toList()[index].CaptData) ,
                  id.toString()+': '+data["Type"].toString(),
                  maxLines: 4,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(data["Date"].toString()),
                trailing: data.containsKey('GPS')
                      ? Text('X: '+data['GPS']['LAT'] +
                          "\nY: " +
                          data['GPS']['LONG'] +
                          "\nZ: " +
                          data['GPS']['ALT'])
                      : null,
                children: [
                  //Text((data.keys+": ")+data.values.toList().iterator.toString()),
                  
    
                 
                   //if()
                  // data.keys.toList()!="GPS" || data.keys.toList()!="Date" ?
                   for(var i=0;i<data.length;i++)
                   (data.keys.toList()[i]!='Date' && data.keys.toList()[i]!='Type' && data.keys.toList()[i]!='GPS')?
                   Text(data.keys.toList()[i].toString() +
                       ': ' +
                       data.values.toList()[i].toString()):Container(),
                 
                         
                        
                  buildbuttons(context, id)
                  
                ],
              ),
            );
          });
  }


  Widget button() {
    return MaterialButton(
      onPressed: (() {
        
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
  final response= await Session().get(url);
   serverdata=jsonDecode(response.body) as List;
    datanotifier.value=serverdata;
  
}


 Widget buildbuttons(BuildContext context, var data) {
   return Row(
     children: [
       Expanded(
         child: TextButton.icon(
           label: Text('Delete'),
           icon: Icon(Icons.delete),
           onPressed: () =>showdialog(data),
         ),
       )
     ],
   );
 }

  Future showdialog(var data){
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

  void deletedata(var data) async{
    if(data!=0){
      http.Response response=await Session().delete(url,jsonEncode(data));
      print(response.body);
    }
    getdatafromserver();
  }
}
