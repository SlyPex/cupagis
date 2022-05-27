import 'package:flutter/material.dart';
import 'package:cupajis/input.dart';
import 'package:cupajis/output.dart';

class Base extends StatefulWidget {
  const Base({ Key? key }) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  var pages=[Input(),outputpage()];
int _selecteditem=0;
@override
void initState(){
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(),
      body:IndexedStack(children: pages,index: _selecteditem,)
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
}