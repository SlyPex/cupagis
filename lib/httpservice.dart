import 'dart:io';
import 'package:cupajis/parameters.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  server srv=server();
  static String auth="";
 late SharedPreferences prefs;

String loginurl="/login";

Future<http.Response> checklogin()async{
  loginurl=srv.geturl()+loginurl;
  prefs=await SharedPreferences.getInstance();
  auth=(await prefs.getString('api_key'))!;
  http.Response response=await http.get(Uri.parse(loginurl),headers: {
    HttpHeaders.authorizationHeader: auth
  });
  return response;
}
 Future<http.Response> login( dynamic data) async {
  loginurl=srv.geturl()+loginurl;
    http.Response response = await http.post(Uri.parse(loginurl), body: data);
    if(response.body=="login success"){
    var header=response.headers['api-key'];
    auth=header!;
    prefs= await SharedPreferences.getInstance();
    prefs.setString('api_key', auth);}
    
    return response;
  }

  Future<http.Response> get(String url) async {
    url=srv.geturl()+url;
    http.Response response = await http.get(Uri.parse(url),headers: {
      HttpHeaders.authorizationHeader: auth,
    });
    return response;
  }

 Future<http.Response> post(String url,var data) async {
  url=srv.geturl()+url;
    http.Response response = await http.post(Uri.parse(url),body:data,headers: {
      HttpHeaders.authorizationHeader: auth,
    });
    return response;
  }

 Future<http.Response> delete(String url,var data) async {
  url=srv.geturl()+url;
    http.Response response = await http.delete(Uri.parse(url),body:data,headers: {
      HttpHeaders.authorizationHeader: auth,
    });
    return response;
  }


 Future<http.Response> logout()async{
   String url=srv.url+"/logout";
   prefs=await SharedPreferences.getInstance();
   http.Response response=await http.get(Uri.parse(url),headers: {
     HttpHeaders.authorizationHeader:auth
   });
  if(response.statusCode==200)
  await prefs.remove('api_key');
  return response;
 }
}