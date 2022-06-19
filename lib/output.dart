import 'dart:convert';
import 'package:cupajis/pages/SignIn.dart';
import 'package:cupajis/parameters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List datas =[];
  var keys=Boxes.getdata().keys.toList().cast<int>();
  final scrollcontroller = ScrollController();
  List serverdata=[];
  final ValueNotifier datanotifier=ValueNotifier([]);
  String url="";
  @override
  void initState(){
    super.initState();
     refresh();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCDCDC),
        appBar:  AppBar(
          actions: [
            Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          refresh();  
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
                   return silverlist();
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


Widget silverlist(){
  return CustomScrollView(
      slivers: [
     
       title("locale data"),
       datas.isEmpty ? caselistempty():
         SliverList(
          
            delegate: SliverChildBuilderDelegate((BuildContext context,int index)  {
             var data= jsonDecode(datas[index].CaptData);
               var  key=keys[index%datas.length];
               
              return article(data, key,datas[index%datas.length].id, index%datas.length);
            },
            childCount: datas.length,
            )
          ),
        
       title("sever data"),
       serverdata.isEmpty ? caselistempty():
      SliverList(delegate: SliverChildBuilderDelegate((BuildContext context,int index) {
       var data=serverdata[index]['data'];
              var  id=serverdata[index]['id'];
             var key=0;
        return article(data,key, id, index);
      },
      childCount: serverdata.length
      ))
      ],
    
  );
}

Widget title(String title){
  return SliverToBoxAdapter(
           child: Container(
            margin: EdgeInsets.only(top: 20),
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
              ),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(title,style: TextStyle(fontSize: 20),),
            ),
    );
}

Widget caselistempty(){
  return SliverToBoxAdapter(
       child:  Container(
        margin: EdgeInsets.only(bottom: 20),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(20.0),
                    bottomRight: const Radius.circular(20.0),
                  ),
              ),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text("there is no data",style: TextStyle(fontSize: 20),),
            ),
          
        
      
     );
}

Widget article(dynamic data,int key,int id,int index){
  return  Container(
    padding: EdgeInsets.all(10),
    color: Colors.white,
    child: Card(
        elevation: 5,
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
                
    ),
  );
}


Future<void> getdatafromserver() async {
  final response= await Session().get(url);
  if(response["success"]){
 serverdata=jsonDecode(response["result"].body) as List;
  for(var i in datas){
     serverdata.removeWhere((element) => element['id']==i.id);
   }
   
    datanotifier.value=serverdata; 
  }
  
  
}

Future<void> refresh()async{
  datas=await Boxes.getdata().values.toList().cast<datalist>();
  datanotifier.value=datas;
  getdatafromserver();
}

 Widget buildbuttons(BuildContext context, var key,var id) {
   return Row(
     children: [
       Expanded(
         child: TextButton.icon(
           label: Text('Delete'),
           icon: Icon(Icons.delete),
           onPressed: () =>showdialog(key,id),
         ),
       )
     ],
   );
 }

  Future showdialog(var key,var id){
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
              deletedata(key,id);
              Navigator.pop(context);
            }, child: Text("DELETE")),
          ],
        );
      }
    );
  }

  void deletedata(var key,var id) async{
    if(id!=0){
      var response=await Session().delete(url,jsonEncode(id));
      
      if(response['result'].statusCode==200)
      showtoast(response['result'].body);
    }
    var box=Boxes.getdata();
    if(box.containsKey(key))
    box.get(key)?.delete();
refresh();
    
    
    
  }

  void showtoast(String msg)=>Fluttertoast.showToast(
    msg: msg,
    fontSize: 16,
    );

   void logout() async{
    http.Response response= await Session().logout();
    if(response.statusCode==200)
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLogin()));
  }
}

