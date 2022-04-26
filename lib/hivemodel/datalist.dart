import 'package:hive/hive.dart';

part  'datalist.g.dart';

@HiveType(typeId: 0)
class datalist extends HiveObject{
  @HiveField(0)
  late String CaptData;

  @HiveField(1)
  late int id;
}
