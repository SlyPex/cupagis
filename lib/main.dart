import 'dart:convert';

import 'package:cupajis/pages/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:cupajis/base.dart';
import 'package:http/http.dart' as http;
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

@override
void initState(){
  super.initState();  
  userstate();
}
  @override
  Widget build(BuildContext context) {
    
   //return Scaffold(
   //  // bottomNavigationBar: NavigationBar(),
   // 
   //   body:isconnected ?  Base(): MyLogin()
   //   );
   Widget retval;
   switch(status){
     case authstatus.offline:
     retval=MyLogin();
     break;
     case authstatus.online:
     retval=Base();
     break;
   }
   return retval;
  }


  Future<void> userstate()async{
    http.Response response=await Session().checklogin();
    print(response.body);
    if(response.body=="user is online"){
      setState(() {
        status=authstatus.online;
      });
      
    }
  }
  
     @override
  void dispose() {
    Hive.close();
    super.dispose();
    
  }
}


