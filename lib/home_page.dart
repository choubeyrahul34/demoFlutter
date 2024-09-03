import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _sendDeviceInfoToBackend();
  }

  Future<void> _sendDeviceInfoToBackend() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;

    // Extracting more unique device information
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String timezone = DateTime.now().timeZoneName;
    int deviceMemory = webBrowserInfo.deviceMemory ?? 0;

    // Generate or retrieve a unique identifier for the device
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? uniqueId = prefs.getString('uniqueId');
    // if (uniqueId == null) {
    //   uniqueId = const Uuid().v4();
    //   await prefs.setString('uniqueId', uniqueId);
    // }

    // Combine with previous properties for more uniqueness
    String userAgent = webBrowserInfo.userAgent ?? 'Unknown';
    String vendor = webBrowserInfo.vendor ?? 'Unknown';
    String platform = webBrowserInfo.platform ?? 'Unknown';
    String appVersion = webBrowserInfo.appVersion ?? 'Unknown';
    String appName = webBrowserInfo.appName ?? 'Unknown';
    int hardwareConcurrency = webBrowserInfo.hardwareConcurrency ?? 0;
    String language = webBrowserInfo.language ?? 'Unknown';

    // Print the device information to the terminal
    debugPrint('User Agent: $userAgent');
    debugPrint('Vendor: $vendor');
    debugPrint('Platform: $platform');
    debugPrint('App Version: $appVersion');
    debugPrint('App Name: $appName');
    debugPrint('Hardware Concurrency: $hardwareConcurrency');
    debugPrint('Language: $language');
    debugPrint('Screen Width: $screenWidth');
    debugPrint('Screen Height: $screenHeight');
    debugPrint('Timezone: $timezone');
    debugPrint('Device Memory: $deviceMemory');
    // debugPrint('Unique ID: $uniqueId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Signup Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the signup form (to be implemented)
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
