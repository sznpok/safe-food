// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/providers/room_provider.dart';
// import '/widgets/curved_body_widget.dart';
// import '/widgets/general_alert_dialog.dart';
// import '/widgets/general_bottom_sheet.dart';

// class ListRoomScreen extends StatelessWidget {
//   const ListRoomScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("List of Rooms"),
//       ),
//       body: CurvedBodyWidget(
//         widget: Consumer<RoomProvider>(
//           builder: (_, value, __) => ListView.builder(
//             itemBuilder: (_, index) {
//               return ListTile(
//                 title: Text(value.listOfRoom[index].name),
//                 trailing: const Icon(Icons.edit_outlined),
//                 onTap: () async {
//                   try {
//                     final newRoomName = await GeneralBottomSheet()
//                         .customBottomSheet(context,
//                             roomName: value.listOfRoom[index].name);
//                     if (newRoomName != null &&
//                         value.listOfRoom[index].name !=
//                             newRoomName.toString().trim()) {
//                       GeneralAlertDialog().customLoadingDialog(context);
//                       await value.updateRoom(context,
//                           newRoomName: newRoomName,
//                           roomId: value.listOfRoom[index].id!);

//                       Navigator.pop(context);
//                     }
//                   } catch (ex) {
//                     Navigator.pop(context);
//                     GeneralAlertDialog()
//                         .customAlertDialog(context, ex.toString());
//                   }
//                 },
//               );
//             },
//             itemCount: value.listOfRoom.length,
//             shrinkWrap: true,
//           ),
//         ),
//       ),
//     );
//   }
// }
