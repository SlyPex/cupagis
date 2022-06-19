import 'dart:convert';
import 'package:cupajis/httpservice.dart';
import 'package:cupajis/parameters.dart';
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
                   Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(right: 10),
                    child: InkWell(
                      child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                       const Radius.circular(20.0),
                      
                                      ),
                                  ),
                              
                                 child: Icon(
                              Icons.settings,
                              size: 26.0,
                            ),
                              ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>parameter()));
                          },  
                    ),
             ),

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
                                      color: Colors.white,
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




  Future <void> login() async{
var response=await Session().login(jsonEncode({"username":email,"password":password}));
if(response['result'].body=="login success"){
 
  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Base()))
  );
   showtoast(response['result'].body);
   
}else showerror(response['result'].body);

 }


void showerror(String msg)=>Fluttertoast.showToast(
  msg: msg,
  toastLength: Toast.LENGTH_LONG,
  backgroundColor: Colors.red
);




   void showtoast(String msg)=>Fluttertoast.showToast(
    msg: msg,
    fontSize: 16,
    );
}
