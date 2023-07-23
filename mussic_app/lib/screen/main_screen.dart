// import 'package:flutter/material.dart';
// import 'package:mussic_app/component/app_assets.dart';
// import 'package:mussic_app/component/app_color.dart';
// import 'package:mussic_app/model/temp.dart';
// import 'package:mussic_app/screen/home_screen.dart';
// import 'package:mussic_app/screen/play_mussic_screen.dart';
// import 'package:mussic_app/screen/user_screen.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

 int currenIndexBottomBar = 0;

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   static final String routeName = 'homecreen';

//   @override
//   State<MainScreen> createState() => _HomeCreenState();
// }

// class _HomeCreenState extends State<MainScreen> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       body: HomeScreen(),
//       bottomNavigationBar: Container(
//         height: 70,
//         decoration: BoxDecoration(
//           color: Colors.black,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   currenIndexBottomBar = 0;
//                 });
//               },
//               child: Container(
//                 height: 30,
//                 child: Image.asset(
//                   appAsset.iconHeadPhone, 
//                   color: currenIndexBottomBar == 0 ? null : Colors.white,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   currenIndexBottomBar = 1;
//                 });
//               },
//               child: Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25),
//                     image: DecorationImage(
//                       image: AssetImage(listMussic[0].avatar),
//                       fit: BoxFit.fill
//                     )
//                   ),
//                 ),
//               ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   currenIndexBottomBar = 2;
//                 });
//               },
//               child: Container(
//                 height: 30,
//                 child: Image.asset(
//                   appAsset.iconUser, 
//                   color: currenIndexBottomBar == 2 ? null : Colors.white,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }