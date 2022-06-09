import 'dart:convert';
import 'package:cupajis/httpservice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SignUp.dart';
import 'package:cupajis/base.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome\nBack',
                      style: TextStyle(color: Colors.black, fontSize: 33),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Color.fromARGB(255, 120, 77, 77),
                                    onPressed: () {
                                      login();
                                     
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyRegister()));
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 // String url="http://192.168.43.149:5000/login";
  Future <void> login() async{
 //  http.Response response=await http.post(Uri.parse(url),body: jsonEncode({"username":email,"password":password}));
 //if(response.statusCode==200){
 //  print("heeeloo");
 //      print(jsonDecode(response.body));
 //      print("bitch");
 //    }else{
 //      print(response.statusCode.toString());
 //    }
var response=await Session().login(jsonEncode({"username":email,"password":password}));
showtoast(response.body);
//if(response.body=="login success"){
   Navigator.pushReplacement(
      context,
     MaterialPageRoute(
   builder: (context) => Base()));
//}
//var i=header?.indexOf(';');
//header=header?.substring(0,i);

//print(thisresponse.headers);
//http.Response response=await http.post(Uri.parse(url),body: jsonEncode({"username":email,"password":password}));
//print(response.headers);
//var header=response.headers['set-cookie'];
//print(header);
//http.Response postresponse =await http.get(Uri.parse(url), headers: {HttpHeaders.authorizationHeader:header.toString()});
//print(postresponse.headers);
//print(postresponse.body);
 }
   void showtoast(String msg)=>Fluttertoast.showToast(
    msg: msg,
    fontSize: 16,
    );
}
