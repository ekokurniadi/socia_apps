import 'package:aplikasi_komun/pages/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String idUser = '';
  String level = '';

  ambilProfil() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var xUser = sharedPreferences.get("id");
    var xrole = sharedPreferences.get("level");
    print("ID USER : $xUser");
    print("Level : $xrole");
    setState(() {
      idUser = xUser;
      level = xrole;
    });
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
    ambilProfil();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      // cek ada sesion login saat ini
      if (idUser == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Auth()));
      } else if (idUser != null && level == "User") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => null));
      }
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF0c53a0)),
              child: Center(
                  child: Text(
                "K",
                style: GoogleFonts.poppins(
                    fontSize: 100.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              )),
            ),
            Container(
              child: Text(
                "Komun Apps",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

