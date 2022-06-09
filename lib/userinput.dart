import 'package:flutter/material.dart';
// ignore: must_be_immutable
class inputform extends StatelessWidget {
  String? label;
  TextEditingController val;
  TextInputType type;
 
   inputform(this.label,this.val,this.type, { Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                  child:  TextField(
                    decoration: InputDecoration(
                        labelText: label, border: OutlineInputBorder()),
                    toolbarOptions: ToolbarOptions(
                        copy: true, cut: true, paste: false, selectAll: true),
                    keyboardType: type,
                    controller: val,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 22, 0, 22));
  }
}