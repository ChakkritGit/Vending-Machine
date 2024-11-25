// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vending_standalone/src/blocs/dispense/dispense_bloc.dart';
// import 'package:vending_standalone/src/models/dispense/dispense_order_model.dart';
// import 'package:vending_standalone/src/models/users/user_model.dart';
// import 'package:vending_standalone/src/services/serialport.dart';
// import 'package:vending_standalone/src/widgets/md_widget/popup_dialog_animation.dart';
// import 'package:vending_standalone/src/widgets/md_widget/popup_dialog_success.dart';

// class OrderBloc extends StatefulWidget {
//   final Users user;
//   final VendingMachine vending;
//   const OrderBloc({super.key, required this.user, required this.vending});

//   @override
//   State<OrderBloc> createState() => _OrderBlocState();
// }

// class _OrderBlocState extends State<OrderBloc> {
//   List<Map<String, dynamic>> itemsToUpdate = [];
//   List<int> writedata = [];

//   late SharedPreferences prefs;
//   int running = 1;
//   int countRound = 0;
//   int qty = 0;
//   int floor = 20;
//   bool isDispense = false;
//   bool nextRound = false;
//   String progress = 'ready';

//   Future<bool> sendToMachine(
//     int dispenseQty,
//     int position,
//     int summaryQty,
//   ) async {
//     Completer<bool> completer = Completer<bool>();
//     if (kDebugMode) {
//       print("Phase 3");
//     }
//     qty = dispenseQty;
//     countRound += dispenseQty;

//     try {
//       if (nextRound) {
//         progress = 'dispensing';
//         writeSerialttyS1(position);
//       }

//       if (!nextRound) widget.vending.writeSerialttyS2('# 1 1 3 1 6');
//       isDispense = true;

//       if (widget.vending.ttyS1.isOpen && widget.vending.ttyS2.isOpen) {
//         widget.vending.upcomingDatattyS1().listen(
//           (data) async {
//             List<String> resData =
//                 data.map((e) => e.toRadixString(16)).toList();
//             String response = resData.join(',');
//             if (kDebugMode) {
//               print('port1: $response');
//             }

//             if (response == 'fa,fb,41,0,40') {
//               if (writedata.isEmpty) {
//                 widget.vending.ttyS1
//                     .write(Uint8List.fromList([0xfa, 0xfb, 0x42, 0x00, 0x43]));
//               } else {
//                 widget.vending.ttyS1.write(Uint8List.fromList(writedata));
//                 if (progress == 'dispensing') qty = qty - 1;
//                 writedata = [];

//                 if (kDebugMode) {
//                   print("Phase 7");
//                 }
//               }
//             } else if (response.startsWith('fa,fb,4,4')) {
//               if (progress == 'dispensing') {
//                 if (qty == 0) {
//                   if (countRound < summaryQty) {
//                     if (kDebugMode) {
//                       print("Phase 7.1");
//                     }
//                     nextRound = true;
//                     completer.complete(true);
//                   } else {
//                     if (kDebugMode) {
//                       print("Phase 8");
//                     }
//                     backToHome();
//                   }
//                 } else {
//                   writeSerialttyS1(position);
//                   if (kDebugMode) {
//                     print('หยิบต่อเนื่อง');
//                   }
//                 }
//               }
//             } else {
//               widget.vending.ttyS1
//                   .write(Uint8List.fromList([0xfa, 0xfb, 0x42, 0x00, 0x43]));
//             }
//           },
//         );

//         widget.vending.upcomingDatattyS2().listen(
//           (data) {
//             List<String> response =
//                 data.map((e) => e.toRadixString(16)).toList();
//             if (kDebugMode) {
//               print("port2: $response");
//             }
//             if (isDispense) {
//               switch (response.join(',')) {
//                 case '26,31,d,a,32,d,a,33,d,a,31,d,a,37,d,a':
//                   // if (kDebugMode) {
//                   //   print('ล็อคกลอนแล้ว');
//                   // }
//                   if (kDebugMode) {
//                     print("Phase 4");
//                   }
//                   // ล็อกกลอน
//                   // สั่งเปิดประตู
//                   widget.vending.writeSerialttyS2('# 1 1 5 10 17');
//                   progress = 'doorOpened';
//                   break;
//                 case '26,31,d,a,32,d,a,35,d,a,31,d,a,39,d,a':
//                   // if (kDebugMode) {
//                   //   print('ประตูเปิดแล้ว');
//                   // }
//                   if (kDebugMode) {
//                     print("Phase 5");
//                   }
//                   // ประตูเปิดแล้ว
//                   // สั่งลิฟต์ขึ้นตามชั้น
//                   switch (position) {
//                     case <= 10:
//                       floor = 1400;
//                     case <= 20:
//                       floor = 1210;
//                     case <= 30:
//                       floor = 1010;
//                     case <= 40:
//                       floor = 790;
//                     case <= 50:
//                       floor = 580;
//                     case <= 60:
//                       floor = 360;
//                     default:
//                       floor = 20;
//                   }

//                   widget.vending.writeSerialttyS2(
//                       '# 1 1 1 ${floor.toString()} ${floor + 1 + 1 + 1}');
//                   progress = 'liftUp';
//                   break;
//                 case '26,31,d,a,32,d,a,31,d,a,31,d,a,35,d,a':
//                   // ลิฟต์ขึ้นและลงแล้ว
//                   if (progress == 'liftUp') {
//                     // if (kDebugMode) {
//                     //   print('ลิฟต์ขึ้นมาแล้ว');
//                     // }
//                     if (kDebugMode) {
//                       print("Phase 6");
//                     }
//                     // สั่งหยิบ
//                     progress = 'dispensing';
//                     writeSerialttyS1(position);
//                   } else if (progress == 'liftDown') {
//                     // if (kDebugMode) {
//                     //   print('ลิฟต์ลงมาแล้ว');
//                     // }
//                     if (kDebugMode) {
//                       print("Phase 9");
//                     }
//                     // สั่งปิดประตู
//                     widget.vending.writeSerialttyS2('# 1 1 6 10 18');
//                     progress = 'doorClosed';
//                   }
//                   break;
//                 case '26,31,d,a,32,d,a,36,d,a,31,d,a,31,30,d,a':
//                   // if (kDebugMode) {
//                   //   print('ประตูปิดแล้ว');
//                   // }
//                   if (kDebugMode) {
//                     print("Phase 10");
//                   }
//                   // ประตูปิดแล้ว
//                   // สั่งปลดล็อกกลอน
//                   widget.vending.writeSerialttyS2('# 1 1 3 0 5');
//                   progress = 'rackUnlocked';
//                   break;
//                 case '26,31,d,a,32,d,a,33,d,a,30,d,a,36,d,a':
//                   // if (kDebugMode) {
//                   //   print('ปลดล็อคกลอนแล้ว');
//                   // }
//                   if (kDebugMode) {
//                     print("Phase 11");
//                   }
//                   // ปลอดล็อกกลอนแล้ว
//                   // กลับคืนค่าเริ่มต้น
//                   progress = 'ready';
//                   isDispense = false;
//                   nextRound = false;
//                   countRound = 0;
//                   qty = 0;
//                   floor = 20;
//                   completer.complete(true);
//                   if (kDebugMode) {
//                     print("Completer: ${completer.isCompleted}");
//                   }
//                   break;
//                 default:
//               }
//             }
//           },
//         );
//       }
//     } catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//       completer.completeError(error);
//       rethrow;
//     }
//     return completer.future;
//   }

//   Future<bool> processOrder(Dispense order) async {
//     if (kDebugMode) {
//       print("Phase 2");
//     }
//     int totalQty = order.qty;
//     itemsToUpdate = [];

//     for (var inventory in order.drug.inventoryList) {
//       if (totalQty <= 0) break;

//       int inventoryQty = inventory.inventoryQty ?? 0;
//       int inventoryPosition = inventory.inventoryPosition ?? 0;
//       int qtyToDeduct = 0;

//       if (totalQty > 0) {
//         if (totalQty > inventoryQty) {
//           qtyToDeduct = inventoryQty;
//           totalQty -= qtyToDeduct;
//           inventory.inventoryQty = 0;
//         } else {
//           qtyToDeduct = totalQty;
//           inventory.inventoryQty = inventoryQty - qtyToDeduct;
//           totalQty = 0;
//         }

//         if (qtyToDeduct > 0) {
//           var success =
//               await sendToMachine(qtyToDeduct, inventoryPosition, order.qty);
//           if (!success) return false;

//           itemsToUpdate.add({
//             'inventoryId': inventory.inventoryId,
//             'quantity': qtyToDeduct,
//           });
//         }
//       }
//     }
//     // if (kDebugMode) {
//     //   print('รอบ: $totalQty');
//     // }
//     return totalQty <= 0;
//   }

//   void writeSerialttyS1(int slot) {
//     List<int> commands = [
//       0xfa,
//       0xfb,
//       0x06,
//       0x05,
//       running,
//       0x00,
//       0x00,
//       0x00,
//       slot
//     ];
//     int checksum = 0;
//     for (var element in commands) {
//       if (element == 0xfa) {
//         checksum = 0xfa;
//       } else {
//         checksum = checksum ^ element;
//       }
//     }
//     commands.add(checksum);
//     writedata = commands;
//     running = running == 255 ? 1 : running + 1;
//     prefs.setInt('running', running);
//     List<String> response = writedata.map((e) => e.toRadixString(16)).toList();
//     if (kDebugMode) print("ttyS1 Write: ${response.join(',')}");
//   }

//   void backToHome() async {
//     progress = 'liftDown';
//     await Future.delayed(const Duration(seconds: 1));
//     widget.vending.writeSerialttyS2("# 1 1 1 -1 2");
//     if (kDebugMode) {
//       print('ลิฟต์กำลังลง');
//     }
//   }

//   Future<void> handleSuccess(Dispense order) async {
//     if (mounted) {
//       // Navigator.popUntil(
//       //   context,
//       //   ModalRoute.withName('/home'),
//       // );
//       Navigator.pop(context);
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => PopupDialogSuccess(
//           itemsToUpdate: itemsToUpdate,
//           icon: Icons.check_circle_outline_rounded,
//           content: 'กรุณารับยาที่ช่องรับยาด้านล่าง',
//           textButton: 'ตกลง',
//           title: 'จัดยาสำเร็จ',
//           user: widget.user,
//           order: order,
//         ),
//       );
//       context.read<DispenseBloc>().add(const DispenseList(dispenseOrder: []));
//       if (kDebugMode) {
//         print(itemsToUpdate);
//       }

//       if (kDebugMode) {
//         print("qty: $qty");
//         print("running: ${running.toString()}");
//         print("countRound: $countRound");
//         print("floor: ${floor.toString()}");
//         print("isDispense: ${isDispense.toString()}");
//         print("nextRound: ${nextRound.toString()}");
//         print("progress: ${progress.toString()}");
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     SharedPreferences.getInstance().then((value) {
//       running = value.getInt('running') ?? 1;
//       prefs = value;
//     });
//   }

//   @override
//   void dispose() {
//     widget.vending.disconnectPort();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DispenseBloc, DispenseState>(
//       listener: (context, state) async {
//         if (state.dispenseOrder.isNotEmpty) {
//           final order = state.dispenseOrder[0];

//           if (kDebugMode) {
//             print("Phase 1");
//           }

//           // เริ่ม animation
//           if (mounted) {
//             showDialog(
//               barrierDismissible: false,
//               context: context,
//               builder: (context) => const PopupDialogAnimation(),
//             );
//           }

//           var completely = await processOrder(order);

//           if (completely) {
//             if (kDebugMode) {
//               print("Phase 12");
//             }
//             await handleSuccess(order);
//           }
//         }
//       },
//       child: Container(),
//     );
//   }
// }
