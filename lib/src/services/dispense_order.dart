import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vending_standalone/src/services/serialport.dart';

class DispenseOrder extends ChangeNotifier {
  late SharedPreferences prefs;
  StreamSubscription<List<int>>? streamSubscriptionS1;
  StreamSubscription<List<int>>? streamSubscriptionS2;

  List<int> writedata = [];

  final VendingMachine vending;
  String progress = 'ready';
  int qty = 0;
  int running = 1;
  int floor = -1;
  int countRound = 0;
  bool isDispense = false;
  bool nextRound = false;

  DispenseOrder({required this.vending}) {
    connectPort();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    running = prefs.getInt('running') ?? 1;
  }

  Future<bool> sendToMachine(
      int dispenseQty, int position, int summaryQty) async {
    Completer<bool> completer = Completer<bool>();
    qty = dispenseQty;
    countRound += dispenseQty;

    if (kDebugMode) {
      print("ช่องที่: $position");
      print("จำนวนที่สั่ง: $dispenseQty");
    }

    try {
      if (nextRound) {
        progress = 'dispensing';
        writeSerialttyS1(position);
      }

      if (!nextRound) {
        vending.writeSerialttyS2('# 1 1 3 1 6');
      }
      isDispense = true;

      if (vending.ttyS1.isOpen && vending.ttyS2.isOpen) {
        streamSubscriptionS1 = vending.upcomingDatattyS1().listen(
          (data) async {
            List<String> listenData =
                data.map((e) => e.toRadixString(16)).toList();
            String response = listenData.join(',');

            if (response == 'fa,fb,41,0,40') {
              if (writedata.isEmpty) {
                vending.ttyS1
                    .write(Uint8List.fromList([0xfa, 0xfb, 0x42, 0x00, 0x43]));
              } else {
                await Future.delayed(const Duration(milliseconds: 500));
                vending.ttyS1.write(Uint8List.fromList(writedata));
                qty = qty - 1;
              }
            } else if (response.startsWith('fa,fb,4,4')) {
              writedata = [];
              if (progress == 'dispensing') {
                if (qty <= 0) {
                  if (countRound < summaryQty) {
                    if (!completer.isCompleted) {
                      nextRound = true;
                      streamSubscriptionS1?.pause();
                      streamSubscriptionS1?.cancel();
                      await Future.delayed(const Duration(milliseconds: 500));
                      completer.complete(true);
                    }
                  } else {
                    backToHome();
                  }
                } else {
                  writeSerialttyS1(position);
                }
              }
            } else {
              if (writedata.isEmpty) {
                vending.ttyS1
                    .write(Uint8List.fromList([0xfa, 0xfb, 0x42, 0x00, 0x43]));
              }
            }
          },
          onError: (error) {
            if (kDebugMode) {
              print("Error in ttyS1 stream: $error");
            }
            vending.disconnectPort();
          },
        );

        streamSubscriptionS2 = vending.upcomingDatattyS2().listen(
          (data) async {
            List<String> response =
                data.map((e) => e.toRadixString(16)).toList();

            if (isDispense) {
              switch (response.join(',')) {
                case '26,31,d,a,32,d,a,33,d,a,31,d,a,37,d,a':
                  // ล็อกกลอน
                  // สั่งเปิดประตู
                  vending.writeSerialttyS2('# 1 1 5 10 17');
                  progress = 'doorOpened';
                  break;
                case '26,31,d,a,32,d,a,35,d,a,31,d,a,39,d,a':
                  // ประตูเปิดแล้ว
                  // สั่งลิฟต์ขึ้นตามชั้น
                  switch (position) {
                    case <= 10:
                      floor = 1400;
                    case <= 20:
                      floor = 1210;
                    case <= 30:
                      floor = 1010;
                    case <= 40:
                      floor = 790;
                    case <= 50:
                      floor = 580;
                    case <= 60:
                      floor = 360;
                    default:
                      floor = 20;
                  }
                  vending.writeSerialttyS2(
                      '# 1 1 1 ${floor.toString()} ${floor + 1 + 1 + 1}');
                  progress = 'liftUp';
                  break;
                case '26,31,d,a,32,d,a,31,d,a,31,d,a,35,d,a':
                  // ลิฟต์ขึ้นและลงแล้ว
                  if (progress == 'liftUp') {
                    // สั่งหยิบ
                    progress = 'dispensing';
                    writeSerialttyS1(position);
                  } else if (progress == 'liftDown') {
                    // สั่งปิดประตู
                    vending.writeSerialttyS2('# 1 1 6 10 18');
                    progress = 'doorClosed';
                  }
                  break;
                case '26,31,d,a,32,d,a,36,d,a,31,d,a,31,30,d,a':
                  // ประตูปิดแล้ว
                  // สั่งปลดล็อกกลอน
                  progress = 'rackUnlocked';
                  vending.writeSerialttyS2('# 1 1 3 0 5');
                  break;
                case '26,31,d,a,32,d,a,33,d,a,30,d,a,36,d,a':
                  // ปลอดล็อกกลอนแล้ว
                  // กลับคืนค่าเริ่มต้น
                  if (progress == "rackUnlocked") {
                    isDispense = false;
                    nextRound = false;
                    countRound = 0;
                    qty = 0;
                    floor = 20;
                    progress = 'ready';
                    completer.complete(true);
                  }
                  break;
                default:
              }
            }
          },
          onError: (error) {
            if (kDebugMode) {
              print("Error in ttyS1 stream: $error");
            }
            vending.disconnectPort();
          },
        );
      } else {
        throw Exception("Serial port is not open.");
      }
    } catch (error) {
      vending.disconnectPort();
      if (kDebugMode) {
        print("SerialPortError: $error");
      }
      completer.completeError(error);
      rethrow;
    }
    return completer.future;
  }

  void writeSerialttyS1(int slot) {
    running = running == 255 ? 1 : running + 1;
    prefs.setInt('running', running);
    List<int> commands = [
      0xfa,
      0xfb,
      0x06,
      0x05,
      running,
      0x00,
      0x00,
      0x00,
      slot
    ];
    int checksum = 0;
    for (var element in commands) {
      if (element == 0xfa) {
        checksum = 0xfa;
      } else {
        checksum = checksum ^ element;
      }
    }
    commands.add(checksum);
    writedata = commands;
  }

  void backToHome() async {
    progress = 'liftDown';
    await Future.delayed(const Duration(seconds: 1));
    vending.writeSerialttyS2("# 1 1 1 -1 2");
  }

  void connectPort() {
    if (!vending.ttyS1.isOpen && !vending.ttyS2.isOpen) {
      vending.connectPort();
    }
  }
}
