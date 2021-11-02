import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utility/settings.dart';
import '../../utility/helper.dart';


class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final Helper helper = Helper();
  bool prosesLogin = false;
  FirebaseMessaging fm = FirebaseMessaging();
  String tokenFcm = "";

  _AuthState(){
    fm.getToken().then((value) => tokenFcm = value);
    fm.configure();
  }

  void login() async{
    setState(() {
      prosesLogin=true;
    });
    final response = await http.post(Settings.BASE_URL + "login",body:{
      "username":_username.text,
      "password":_password.text,
      "token":tokenFcm
    });
    print("token:$tokenFcm");
    final result = jsonDecode(response.body);
    String status = result['status'];
    String message = result['message'];
    String userID = result['user_id'];
    String nama = result['nama']; 
    String username = result['username']; 
    String level = result['level']; 
     if (status == "1") {
      setState(() {
        savePref(userID, nama, username, level);
      });
      setState(() {
        prosesLogin = false;
      });
      helper.alertLog(message);
      // debuging
      print(result);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      setState(() {
        prosesLogin = false;
      });
      helper.alertLog(message);
    }
  }

   savePref(String userID, String nama, String username, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("idUser", userID);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("level", level);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF12558a),
        elevation: 0,
        title: Text(
          "Komun",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xFF12558a),
      body: ModalProgressHUD(
        inAsyncCall: prosesLogin,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF0c53a0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Center(child: Image.asset("assets/user-login.png")),
              ),
              Container(
                margin: EdgeInsets.only(top: 24, left: 24, right: 24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: TextField(
                    controller: _username,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 24, top: 14.0),
                        hintText: "Phone Number",
                        hintStyle: GoogleFonts.poppins(color: Color(0xFF12558a)),
                        prefixIcon: Icon(
                          Icons.people_outline,
                          size: 23,
                        )),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24, top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 24, top: 14.0),
                        hintText: "Password",
                        hintStyle: GoogleFonts.poppins(color: Color(0xFF12558a)),
                        prefixIcon: Icon(
                          Icons.lock,
                          size: 23,
                        )),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute( fullscreenDialog: true,builder: (context) => null));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 40,
                  child: Center(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot Password",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)))),
                ),
              ),
              GestureDetector(
                onTap: () => login(),
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text("SIGN IN",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white))),
                ),
              ),
              GestureDetector(
                onTap: (){
                   Navigator.push(
                      context, MaterialPageRoute( fullscreenDialog: true,builder: (context) => null));
                },
                              child: Container(
                  margin: EdgeInsets.only(top: 18),
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 40,
                  child: Center(
                      child: Text("Create new account",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, color: Colors.white))),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: 3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
