// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:eny/pages/home_page.dart';
import 'package:eny/provider/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isTheme = themeChange.darkTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  width: double.maxFinite,
                  height: 400,
                  decoration: 
                      const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/eny.png",),fit: BoxFit.cover
                          ),
                        ),
                ),
              ]),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                alignment: Alignment.bottomCenter,
                width: 30,
                height: 30,
                child: const CircularProgressIndicator.adaptive(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
