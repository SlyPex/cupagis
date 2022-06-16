import 'dart:convert';
import 'package:cupajis/pages/SignIn.dart';
import 'package:cupajis/parameters.dart';
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
  var datas =Boxes.getdata().values.toList().cast<datalist>();
  var keys=Boxes.getdata().keys.toList().cast<int>();
  List serverdata=[];
  final ValueNotifier datanotifier=ValueNotifier([]);
  String url="";
  @override
  void initState(){
    super.initState();
     getdatafromserver();
     print(datas);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          actions: [
            Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
         datanotifier.value=datas;
        getdatafromserver();
   
        },
        child: Icon(
          Icons.refresh,
          size: 26.0,
        ),
      )
    ),
    
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
          ],
        ),
        body:
           
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
          itemCount: datas.length+serverdata.length,
          itemBuilder: (BuildContext context, index) {
            Map data={};
            var id;
            var key;
             if(index<datas.length){
             data=jsonDecode(datas[index].CaptData);
             key=keys[index];
             
            }else{
               data=serverdata[index-datas.length]['data'];
              id=serverdata[index-datas.length]['id'];
             }
            return Card(
              color: Colors.white,
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title:index<datas.length ? Text(
                 data["Type"].toString(),
                  maxLines: 4,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ):Text(
                  data["Type"].toString(),
                  maxLines: 4,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(data["Date"].toString()),
                trailing: data.containsKey('GPS')
                      ? Text('X: '+data['GPS']['LAT'].toString() +
                          "\nY: " +
                          data['GPS']['LONG'].toString() +
                          "\nZ: " +
                          data['GPS']['ALT'].toString())
                      : null,
                children: [
                   for(var i=0;i<data.length;i++)
                   (data.keys.toList()[i]!='Date' && data.keys.toList()[i]!='Type' && data.keys.toList()[i]!='GPS')?
                   Text(data.keys.toList()[i].toString() +
                       ': ' +
                       data.values.toList()[i].toString()):Container(),
                 
                         
                
                  buildbuttons(context, key,id)
                  
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
  if(response.statusCode==200){
 serverdata=jsonDecode(response.body) as List;
  for(var i in datas){
     serverdata.removeWhere((element) => element['id']==i.id);
   }
   
    datanotifier.value=serverdata; 
  }
  print(serverdata.length);
  
}


 Widget buildbuttons(BuildContext context, var data,var id) {
   return Row(
     children: [
       Expanded(
         child: TextButton.icon(
           label: Text('Delete'),
           icon: Icon(Icons.delete),
           onPressed: () =>showdialog(data,id),
         ),
       )
     ],
   );
 }

  Future showdialog(var data,var id){
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
              deletedata(data,id);
              Navigator.pop(context);
            }, child: Text("DELETE")),
          ],
        );
      }
    );
  }

  void deletedata(var data,var id) async{
    if(id!=0){
      http.Response response=await Session().delete(url,jsonEncode(id));
      print(response.body);
    }
    var box=Boxes.getdata();
    box.get(data)!.delete();

  //datanotifier.value=datas;
   getdatafromserver();
    
    
    
  }

   void logout() async{
    http.Response response= await Session().logout();
    if(response.statusCode==200)
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLogin()));
  }
}
