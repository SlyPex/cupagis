import 'package:hive/hive.dart';
import 'package:cupajis/hivemodel/datalist.dart';
class Boxes{
  static Box<datalist> getdata()=>
  Hive.box<datalist>('datas');
}