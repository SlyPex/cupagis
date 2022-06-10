
import 'package:cupajis/pages/SignIn.dart';
import 'package:cupajis/parameters.dart';
import 'package:flutter/material.dart';
import 'package:cupajis/base.dart';
import 'package:http/http.dart' as http;
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'databox.dart';
import 'httpservice.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(datalistAdapter());
  await Hive.openBox<datalist>('datas');
  runApp(
     MaterialApp(
      title: 'Cupajis',
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
enum authstatus {online,offline}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
static authstatus status=authstatus.offline;
timer timeleft=timer();
bool load=false;
var hivedata=Boxes.getdata();
@override
void initState(){
   userstate();
   timeleft.cleartimer(hivedata);
  super.initState();  
 
}
  @override
  Widget build(BuildContext context) {
    
   if(!load)
   return Scaffold();
   else{
   Widget retval;
   switch(status){
     case authstatus.offline:
     retval=MyLogin();
     break;
     case authstatus.online:
     retval=Base();
     break;
   }
   return retval;}
  }


  Future<void> userstate()async{
    http.Response response=await Session().checklogin();
    if(response.body=="user is online"){
      setState(()   {
        status= authstatus.online;
      }); 
    }
    setState(() {
      load=true;
    });
  }
  
     @override
  void dispose() {
    Hive.close();
    super.dispose();
    
  }
}


