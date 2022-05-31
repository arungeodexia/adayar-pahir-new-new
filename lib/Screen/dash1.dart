// import 'package:ACI/utils/calls_messages_services.dart';
// import 'package:ACI/utils/constants.dart';
// import 'package:ACI/utils/mycircleavatar.dart';
// import 'package:ACI/utils/values/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'ScreenCheck.dart';
// class DashBoardDemo extends StatefulWidget {
//
//   @override
//   State<DashBoardDemo> createState() => _DashBoardDemoState();
// }
//
// class _DashBoardDemoState extends State<DashBoardDemo> {
//   final String avatar = "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media";
//
//   final TextStyle whiteText = TextStyle(color: Colors.white);
//   String username = "";
//
//   String userImage = "";
//   bool isload = false;
//
//   void getsurvey() async {
//     isload = false;
//   }
//   Container _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20.0),
//           bottomRight: Radius.circular(20.0),
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
//         color: AppColors.APP_BLUE1,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           ListTile(
//             title:  Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(3),
//                   child: Center(
//                     child: Text(
//                       "Clinic Visit",
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       maxLines: 3,
//                       style: kSubtitleTextSyule1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         height: 1.5,
//                         color: Colors.white
//                       ),
//                     )
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(3),
//                   child: Center(
//                     child: Text(
//                       "Today",
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       maxLines: 3,
//                       style: kSubtitleTextSyule1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         height: 1.5,
//                           color: Colors.white
//
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(3),
//                   child: Center(
//                     child: Text(
//                       "10.26 AM",
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       maxLines: 3,
//                       style:kSubtitleTextSyule1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         height: 1.5,
//                           color: Colors.white
//
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(3),
//                   child: Center(
//                     child: Text(
//                       "20 minutes appointment",
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       maxLines: 3,
//                       style: kSubtitleTextSyule1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         height: 1.5,
//                           color: Colors.white
//
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             trailing: CircleAvatar(
//               radius: 25.0,
//               backgroundImage: NetworkImage(avatar),
//             ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 20, top: 20, right: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   SvgPicture.asset("assets/icons/menu.svg"),
//                   MyCircleAvatar(imgUrl: "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media")
//                 ],
//               ),
//               SizedBox(height: 30),
//               Text("Hey Alex,", style: kHeadingextStyle),
//               SizedBox(height: 30),
//               _buildHeader(),
//               SizedBox(height: 30),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(3),
//                     child: Text(
//                       "Dr. Melinda Rose,MD (O&G)",
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       maxLines: 3,
//                       style:  kSubtitleTextSyule1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         height: 1.5,
//
//                       ),
//
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(3),
//                     child: Text(
//                       "Cancer Institute",
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       maxLines: 3,
//                       style:  kSubtitleTextSyule1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         height: 1.5,
//
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(3),
//                     child: Text(
//                       "Adayar, Chennai - 20",
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       maxLines: 3,
//                       style:  kSubtitleTextSyule1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       CallsAndMessagesService.call("98435 21693".replaceAll(' ', ''));
//                     },
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.phone_rounded,color: AppColors.APP_LIGHT_BLUE,size: 18,),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 3,bottom: 5,left: 5),
//                           child: Text(
//                             "98435 21693",
//                             overflow: TextOverflow.ellipsis,
//                             softWrap: false,
//                             maxLines: 3,
//                             style:  kSubtitleTextSyule1.copyWith(
//                               fontWeight: FontWeight.w600,
//                               height: 1.5,
//                             ),
//                         ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text("My Tasks", style: kTitleTextStyle),
//                   // Text(
//                   //   "See All",
//                   //   style: kSubtitleTextSyule1.copyWith(color: kBlueColor),
//                   // ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               ListView.builder(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   // physics: NeverScrollableScrollPhysics(),
//                   physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//                   itemCount: 3,
//                   itemBuilder: (BuildContext context,
//                       int index) {
//                     return Container(
//                       height: 60,
//                       padding: EdgeInsets.all(2),
//                       margin: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.grey),
//                       ),
//                       child:                     ListTile(
//
//                         onTap: (){
//                           Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
//                             title: index==0?'Screening Check':'Medication Instruction',
//
//                           )),)
//                               .then((val)=>getsurvey());
//
//                         },
//                         title: Padding(
//                           padding: const EdgeInsets.only(left: 0),
//                           child: Text(index==0?'Screening Check':'Medication Instruction', style:kSubtitleTextSyule1.copyWith(
//                             fontWeight: FontWeight.w600,
//                             height: 1.5,
//                           ),
//                           ),
//                         ),
//                         trailing: Container(
//                           width: 60,
//                           child: Row(
//
//                             children: [
//                               Text(index==0?'65%':'10%', style:kSubtitleTextSyule1.copyWith(
//                                 fontWeight: FontWeight.w600,
//                                 height: 1.5,
//                               ),
//                               ),
//                               SizedBox(width: 4,),
//                               Icon(Icons.arrow_forward_ios,size: 15,color: AppColors.APP_BLUE,),
//
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                     return Card(
//                       color: AppColors.APP_BLUE1,
//                       child:
//                       ListTile(
//
//                         onTap: (){
//                           Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
//                             title: index==0?'Screening Check':'Medication Instruction',
//
//                           )),)
//                               .then((val)=>getsurvey());
//
//                         },
//                         title: Padding(
//                           padding: const EdgeInsets.only(left: 0),
//                           child: Text(index==0?'Screening Check':'Medication Instruction', style:
//                           TextStyle(fontWeight: FontWeight.w400,
//                               fontSize: 15,
//                               color: AppColors.APP_WHITE)
//                           ),
//                         ),
//                         trailing:
//                         Text(index==0?'65%':'10%', style:
//                         TextStyle(fontWeight: FontWeight.w400,
//                             fontSize: 16,
//                             color: AppColors.APP_WHITE)
//                         ),
//                       ),
//                     );
//                   })
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
