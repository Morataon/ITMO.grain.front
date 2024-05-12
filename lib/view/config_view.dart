import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:itmo_grain_frontend/view/home_screen_view.dart';




class SelectBluetoothDevicePage extends StatefulWidget {
  @override
  _SelectBluetoothDevicePageState createState() =>
      _SelectBluetoothDevicePageState();
}

class _SelectBluetoothDevicePageState
    extends State<SelectBluetoothDevicePage> {
  List<BluetoothDevice> devices = [];

  void _getPairedDevices() async {
    List<BluetoothDevice> bondedDevices =
    await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      devices = bondedDevices;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPairedDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bluetooth Device'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].name!),
            subtitle: Text(devices[index].address),
            onTap: () {
              Navigator.of(context).pop(devices[index]);
            },
          );
        },
      ),
    );
  }
}
