import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleService {
  Future<bool> init() async {
    // Request permissions required for Bluetooth scanning
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
    
    // Check hardware status
    if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.off) {
      return false;
    }
    return true;
  }

  Stream<List<ScanResult>> scan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 8));
    return FlutterBluePlus.scanResults;
  }
}