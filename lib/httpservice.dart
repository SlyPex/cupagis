import 'dart:io';
import 'package:cupajis/parameters.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  server srv=server();
  static String auth="";
 late SharedPreferences prefs;

String loginurl="/login";


Future<void> checklogin()async{
  prefs=await SharedPreferences.getInstance();
  auth=(await prefs.getString('api_key'))!;
}
 Future<dynamic> login( dynamic data) async {
  loginurl=srv.geturl()+loginurl;
  try{
    http.Response response = await http.post(Uri.parse(loginurl), body: data);
   if(response.statusCode==200){
    if(response.body=="login success"){
    var header=response.headers['api-key'];
    auth=header!;
    prefs= await SharedPreferences.getInstance();
    prefs.setString('api_key', auth);}
    final jsonresponse={"success": true,"result":response};
    return jsonresponse;}
    } on SocketException {
      final jsonresponse={"success": false,"result":"NO_INTERNET"};
      return jsonresponse;
    } on HttpException{
      final jsonresponse={"success": false,"result":"SOMETHING_WRONG"};
      return jsonresponse;
    }
  }

  Future<dynamic> get(String url) async {
    url=srv.geturl()+url;
    
    try{
    http.Response response = await http.get(Uri.parse(url),headers: {
      HttpHeaders.authorizationHeader: auth,
    });
    if(response.statusCode==200){
    final jsonresponse={"success": true,"result":response};
    return jsonresponse;}
    } on SocketException {
      final jsonresponse={"success": false,"result":"NO_INTERNET"};
      return jsonresponse;
    } on HttpException{
      final jsonresponse={"success": false,"result":"SOMETHING_WRONG"};
      return jsonresponse;
    }
  }

 Future<dynamic> post(String url,var data) async {
  url=srv.geturl()+url;
  try{
    http.Response response = await http.post(Uri.parse(url),body:data,headers: {
      HttpHeaders.authorizationHeader: auth,
    });
    if(response.statusCode==200){
    final jsonresponse={"success": true,"result":response};
    return jsonresponse;}
    } on SocketException {
      final jsonresponse={"success": false,"result":"NO_INTERNET"};
      return jsonresponse;
    } on HttpException{
      final jsonresponse={"success": false,"result":"SOMETHING_WRONG"};
      return jsonresponse;
    }
    }

 Future<dynamic> delete(String url,var data) async {
  url=srv.geturl()+url;
  try{
    http.Response response = await http.delete(Uri.parse(url),body:data,headers: {
      HttpHeaders.authorizationHeader: auth,
    });
    if(response.statusCode==200){
    final jsonresponse={"success": true,"result":response};
    return jsonresponse;}else{
      final jsonresponse={"success": false,"result":response};
      return jsonresponse;
    }
    } on SocketException {
      final jsonresponse={"success": false,"result":"NO_INTERNET"};
      return jsonresponse;
    } on HttpException{
      final jsonresponse={"success": false,"result":"SOMETHING_WRONG"};
      return jsonresponse;
    }
  }


 Future<http.Response> logout()async{
   String url=srv.geturl()+"/logout";
   prefs=await SharedPreferences.getInstance();
   http.Response response=await http.get(Uri.parse(url),headers: {
     HttpHeaders.authorizationHeader:auth
   });
  if(response.statusCode==200)
  await prefs.remove('api_key');
  return response;
 }
}