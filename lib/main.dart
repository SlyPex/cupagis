
import 'package:cupajis/input.dart';
import 'package:cupajis/output.dart';
import 'package:cupajis/pages/SignIn.dart';
import 'package:cupajis/pages/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:cupajis/databox.dart';
import 'package:cupajis/base.dart';
import 'package:http/http.dart' as http;
import 'package:cupajis/hivemodel/datalist.dart';
import 'package:hive_flutter/hive_flutter.dart';


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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

var pages=[Input(),outputpage()];
int _selecteditem=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // bottomNavigationBar: NavigationBar(),
      
        body: Base()
        
        
        
        );
  }

  Widget NavigationBar() {
    return BottomNavigationBar(
      items: [BottomNavigationBarItem(
        icon: Icon(Icons.library_add_rounded, size: 40,),
        label: 'home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted_rounded, size: 40,),
          label: 'save' 
        )],
        currentIndex: _selecteditem,
        onTap: (index){
          setState(() {
            _selecteditem=index;
          });
        },
      );
    
   
  }
  
     @override
  void dispose() {
    Hive.close();
    super.dispose();
    
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