import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
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
  int sec = 0;
  int min = 30;
  String secText = '00';
  String minText = '30';
  Timer? _timer;
  bool _isRunning = true;
  bool _isResting = false;
  final AudioCache _audioCache = AudioCache(prefix: 'assets/sound/');

  @override
  void initState() {
    super.initState();
    _handleTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onDoubleTap: _toggleTimer,
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            _startRestingPeriod();
          } else if (details.delta.dx < 0) {
            _startCountdownPeriod();
          }
        },
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isResting)
                Column(
                  children: [
                    const Text(
                      'Stop',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          minText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 150.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 100.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          secText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 150.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (!_isResting)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      minText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 150.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      ":",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 100.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      secText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 150.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) return;
      setState(() {
        if (_isResting) {
          if (sec == 0 && min == 0) {
            _isResting = false;
            min = 30;
            sec = 0;
            minText = '30';
            secText = '00';
            _handleTimer();
          } else {
            if (sec == 0) {
              sec = 59;
              min--;
            } else {
              sec--;
            }
          }
        } else {
          if (sec == 0) {
            if (min == 0) {
              _timer?.cancel();
              _playSound();
              _isResting = true;
              sec = 0;
              min = 5;
              minText = '05';
              secText = '00';
              _handleTimer();
            } else {
              sec = 59;
              min--;
            }
          } else {
            sec--;
          }
        }

        if (sec > 9) {
          secText = '$sec';
        } else {
          secText = '0$sec';
        }

        if (min > 9) {
          minText = '$min';
        } else {
          minText = '0$min';
        }
      });
    });
  }

  void _startRestingPeriod() {
    setState(() {
      _isRunning = true;
      _isResting = true;
      min = 5;
      sec = 0;
      minText = '05';
      secText = '00';
      _timer?.cancel();
      _handleTimer();
    });
  }

  void _startCountdownPeriod() {
    setState(() {
      _isRunning = true;
      _isResting = false;
      min = 30;
      sec = 0;
      minText = '30';
      secText = '00';
      _timer?.cancel();
      _handleTimer();
    });
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _handleTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _playSound() async {
    await _audioCache.play('end-time.mp3');
  }
}
