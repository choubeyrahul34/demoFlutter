import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:html' as html; // Import dart:html for JavaScript interop

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  late Future<Map<String, dynamic>> _deviceInfoFuture;

  @override
  void initState() {
    super.initState();
    _deviceInfoFuture = _getDeviceInfo();
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;

    // Retrieve or generate a unique device ID
    String deviceId = const Uuid().v4();

    // Get timezone and available screen size using JavaScript interop
    String timeZone = html.window.navigator.language; // Get user's locale
    int? screenWidth = html.window.innerWidth; // Available screen width
    int? screenHeight = html.window.innerHeight; // Available screen height

    // Collect all relevant device information
    Map<String, dynamic> deviceData = {
      'userAgent': webBrowserInfo.userAgent ?? 'Unknown',
      'vendor': webBrowserInfo.vendor ?? 'Unknown',
      'platform': webBrowserInfo.platform ?? 'Unknown',
      'appVersion': webBrowserInfo.appVersion ?? 'Unknown',
      'appName': webBrowserInfo.appName ?? 'Unknown',
      'hardwareConcurrency': webBrowserInfo.hardwareConcurrency ?? 0,
      'language': webBrowserInfo.language ?? 'Unknown',
      'browserName': webBrowserInfo.browserName.name,
      'appCodeName': webBrowserInfo.appCodeName,
      'deviceMemory': webBrowserInfo.deviceMemory,
      'languages': webBrowserInfo.languages,
      'product': webBrowserInfo.product,
      'productSub': webBrowserInfo.productSub,
      'vendorSub': webBrowserInfo.vendorSub,
      'maxTouchPoints': webBrowserInfo.maxTouchPoints,
      'deviceId': deviceId,

      // Additional information
      'timeZone': timeZone, // Add timezone (locale)
      'screenWidth': screenWidth, // Add available screen width
      'screenHeight': screenHeight, // Add available screen height
    };

    return deviceData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _deviceInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: snapshot.data!.entries.map((entry) {
                return ListTile(
                  title: Text('${entry.key}:'),
                  subtitle: Text('${entry.value}'),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('No device information available'));
          }
        },
      ),
    );
  }
}
