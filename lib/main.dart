import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int sec = 60;
  int min = 30;
  String secText= '00';
  String minText = '30';
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleTimer();
  }



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
             Text(minText, style: const TextStyle(color: Colors.white, fontSize: 150.0, fontWeight: FontWeight.bold),),
            const Text(":", style: TextStyle(color: Colors.white, fontSize: 100.0, fontWeight: FontWeight.bold),),
             Text(secText, style: const TextStyle(color: Colors.white, fontSize: 150.0, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }

  void _handleTimer(){
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (min >=30) {
          min--;
          sec--;
        }
        else{
          if(sec == 60){
            min--;
          }
          sec--;
        }
        if(sec > 9){
          secText = '$sec';
        }
        else{
          if(sec > 0){
          secText = '0$sec';
          }
          else{
            sec = 60;
            secText = '00';
          }
        }

        if(min > 9){
          minText = '$min';
        }
        else{
          if(min > 0){
            minText = '0$sec';
          }
          else{
            min = 60;
            minText = '00';
            if(sec == 60){
              _timer?.cancel();
            }
          }
        }

      });
    });
  }

}

