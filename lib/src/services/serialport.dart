import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class VendingMachine {
  late SerialPort ttyS1;
  late SerialPort ttyS2;
  int running = 1;
  List<int> writedata = [];

  VendingMachine();

  void connectPort({int baudRatettyS1 = 57600, int baudRateS2 = 9600}) {
    // Initialize ports only if they are not already initialized
    ttyS1 = SerialPort("/dev/ttyS1");
    ttyS2 = SerialPort("/dev/ttyS2");

    // Open ports for read/write if they are available
    if (ttyS1.isOpen == false) {
      ttyS1.openReadWrite();
    }
    if (ttyS2.isOpen == false) {
      ttyS2.openReadWrite();
    }

    // Configure Serial Port ttyS1
    SerialPortConfig ttyS1conf = SerialPortConfig();
    ttyS1conf.baudRate = baudRatettyS1;
    ttyS1conf.bits = 8;
    ttyS1conf.parity = 0;
    ttyS1conf.stopBits = 1;
    ttyS1conf.xonXoff = 0;
    ttyS1.config = ttyS1conf;

    // Configure Serial Port ttyS2
    SerialPortConfig ttyS2conf = SerialPortConfig();
    ttyS2conf.baudRate = baudRateS2;
    ttyS2conf.bits = 8;
    ttyS2conf.parity = 0;
    ttyS2conf.stopBits = 1;
    ttyS2conf.xonXoff = 0;
    ttyS2.config = ttyS2conf;
  }

  void writeSerialttyS2(String commands) {
    // Convert string command to list of bytes (Uint8List)
    List<int> cmd = commands.codeUnits;
    ttyS2.write(Uint8List.fromList(cmd));
  }

  Stream<Uint8List> upcomingDatattyS1() {
    // Set up the reader for ttyS1 with timeout configuration
    SerialPortReader reader = SerialPortReader(ttyS1, timeout: 10000);
    return reader.stream.map((data) => data);
  }

  Stream<Uint8List> upcomingDatattyS2() {
    // Set up the reader for ttyS2 with timeout configuration
    SerialPortReader reader = SerialPortReader(ttyS2, timeout: 10000);
    return reader.stream.map((data) => data);
  }

  Future disconnectPort() async {
    // Safely close both Serial ports
    ttyS1.close();
    ttyS2.close();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void dispose() {
    // Clean up resources by disposing of the Serial ports
    ttyS1.dispose();
    ttyS2.dispose();
  }
}
