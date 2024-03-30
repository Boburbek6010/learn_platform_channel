import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _batteryLevel = "Level is unavailable";
  String _deviceInfo = "Device info is unavailable";
  final platform = const MethodChannel("com.pdp/battery");

  Future<void> _getBatteryLevel()async{
    String batteryLevel;
    try{
      int result = await platform.invokeMethod("getBatteryLevel");
      batteryLevel = "Battery Level is $result";
    } on PlatformException catch(e){
      batteryLevel = "Error occurred : $e";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }


  Future<void> _getDeviceInfo()async{
    String info;
    try{
      String result = await platform.invokeMethod("deviceInfo");
      info = "======App Info======\n$result";
    } on PlatformException catch(e){
      info = "Info Error: $e";
    }
    setState(() {
      _deviceInfo = info;
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(_batteryLevel),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text("Get Battery Level"),
            ),

            Text(_deviceInfo),
            ElevatedButton(
              onPressed: _getDeviceInfo,
              child: const Text("Get Battery Level"),
            ),
          ],
        ),
      ),
    );
  }
}
