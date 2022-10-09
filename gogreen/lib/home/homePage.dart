// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app_theme.dart';
import '../controllers/navigationController.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.uid}) : super(key: key);
  final String uid;
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userData = {};

  int coins = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data();
      coins = userSnap.data()['coins'];
      setState(() {});
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationController =
        Get.put(NavigationController(), permanent: true);
    return
        // Obx((){
        Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: const SizedBox(
            width: 58,
            height: 58,
            child:
                Icon(Icons.menu_rounded, color: Color.fromRGBO(24, 30, 48, 1)),
          ),
          onTap: () {
            navigationController.advancedDrawerController.showDrawer();
          },
        ),
        leadingWidth: 65,
        actions: [
          GestureDetector(
            onTap: () {
              // navigateToProfilePage();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 24),
              child: CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage("images/boy1.png"),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            homePageGridLayout(context),
            // Custom App Bar
            // getAppBarUI(context, ref),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      // );}
    );
  }

  Widget homePageGridLayout(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // Under Intro
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: SizedBox(
            height: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Hello ${userData['username']}👋',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    letterSpacing: 0.2,
                    color: Color(0xFF3A5160),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Expanded(
                  child: Text(
                    "How are you Feeling today...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Color(0xFF17262A),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "Learn Offline",
                      style: AppTheme.title,
                    ).px(16),
                  ),
                ),
                14.heightBox,
                Container(
                  height: 120,
                  width: context.screenWidth,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                      image: const DecorationImage(
                          image: AssetImage('images/flash.png'),
                          fit: BoxFit.fitWidth),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'images/nomess.png',
                            fit: BoxFit.fitHeight,
                            height: 80,
                          ),
                          20.widthBox,
                          Container(
                            // width: context.screenWidth * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Learn with the Fun!",
                                    textAlign: TextAlign.left,
                                    style: AppTheme.body2.copyWith(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                14.heightBox,
                                Text("Top Courses",
                                        textAlign: TextAlign.center,
                                        style: AppTheme.body2.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                    .py(10)
                                    .w(160)
                                    .box
                                    .white
                                    .outerShadowLg
                                    .roundedSM
                                    .make(),
                              ],
                            ),
                          ),
                        ],
                      ).centered(),
                    ),
                  ),
                ).onTap(() {
                  // Get.to(() => NearbyCenterPage());
                }).px16(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget getAppBarUI(context) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //         top: 0,
  //         left: 8,
  //         right: 24),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         GestureDetector(
  //               child: SizedBox(
  //                 width: (SizeConfig.box60),
  //                 height: (SizeConfig.box60),
  //                 child: Icon(Icons.menu_rounded,
  //                     color: const Color.fromRGBO(24, 30, 48, 1)),
  //               ),
  //               onTap: () {
  //                 ref.read(drawerControllerProvider).showDrawer();
  //               },
  //             ),
  //         Row(
  //           children: [
  //             // SizedBox(
  //             //   width: (SizeConfig.hp * 7.5),
  //             //   height: (SizeConfig.hp * 7.5),
  //             //   child: Icon(Icons.notifications_none_rounded,
  //             //       color: const Color.fromRGBO(24, 30, 48, 1)),
  //             // ),
  //             // SizedBox(
  //             //   width: 4,
  //             // ),
  //             GestureDetector(
  //               onTap: () {
  //                 navigateToProfilePage();
  //               },
  //               child: CircleAvatar(
  //                 radius: (SizeConfig.avatarRadius),
  //                 backgroundImage: CachedNetworkImageProvider(
  //                   profile,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
