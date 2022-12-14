import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gogreen/home/add_post_screen.dart';
import 'package:gogreen/home/feed_screen.dart';
import 'package:gogreen/home/wallletscreen.dart';
import 'package:gogreen/home/profile_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../constant.dart';
import '../controllers/navigationController.dart';
import '../providers/user_provider.dart';

class NavigationWrapper extends StatefulWidget {
  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  final navigationController = Get.put(NavigationController(), permanent: true);
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    _pageController =
        PageController(initialPage: navigationController.currentIndex.value);

    return GetX<NavigationController>(
        builder: (navigationController) => AdvancedDrawer(
              backdropColor: Utils.themeColor,
              drawer: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18.0, right: 16, top: 44),
                      // padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0x003124A1),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color.fromARGB(8, 23, 23, 23),
                                offset: Offset(0, 2),
                              )
                            ],
                            borderRadius: BorderRadius.circular(80),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: const Color.fromRGBO(57, 75, 123, 0.9),
                              width: 1.8,
                            ),
                          ),
                          alignment: const AlignmentDirectional(-0.0, 0),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onTap: () {
                          navigationController.advancedDrawerController
                              .hideDrawer();
                          // refference!.read(drawerControllerProvider).hideDrawer();
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding:
                            const EdgeInsets.only(left: 36, top: 0, bottom: 24),
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                radius: 54,
                                backgroundImage: AssetImage(
                                  "images/gogreenlogo.png",
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 36.0, bottom: 16),
                            child: Text(
                              "Welcome",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                letterSpacing: 0.27,
                                color: Color.fromARGB(255, 205, 209, 223),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            height: 58,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xff132137),
                            ),
                            child: InkWell(
                              onTap: () {
                                navigationController.advancedDrawerController
                                    .hideDrawer();
                                FirebaseAuth.instance.signOut();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    // Icon(Icons.arrow_forward_rounded,
                                    //     color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: MainDrawer(
                    //     context: context,
                    //   ),
                    // )
                  ],
                ),
              ),
              controller: navigationController.advancedDrawerController,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 500),
              animateChildDecoration: true,
              rtlOpening: false,
              openScale: 0.85,
              openRatio: 0.7,
              // disabledGestures: true,
              childDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),

              child: Scaffold(
                backgroundColor: Color.fromRGBO(240, 244, 247, 1),
                body: SizedBox.expand(
                  child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        navigationController.onPageChange(index);
                      },
                      children: <Widget>[
                        FeedScreen(),
                        WalletScreen(
                          uid: FirebaseAuth.instance.currentUser.uid,
                        ),
                        // MyHomePage(
                        //   uid: FirebaseAuth.instance.currentUser.uid,
                        // ),
                        ProfileScreen(
                          uid: FirebaseAuth.instance.currentUser.uid,
                        )
                      ]),
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                    child: GNav(
                      gap: 16,
                      // backgroundColor: Colors.white,
                      activeColor: Colors.white.withOpacity(0.95),
                      iconSize: 21,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: Utils.themeColor, //Colors.grey[100]!,
                      color: HexColorNew('#9DA0AA'),
                      // curve: Curves.slowMiddle,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      tabs: const [
                        GButton(
                          icon: FontAwesomeIcons.tree,
                          text: 'Home',
                        ),
                        GButton(
                          icon: FontAwesomeIcons.wallet,
                          text: 'Wallet',
                        ),
                        GButton(
                          icon: FontAwesomeIcons.userTie,
                          text: 'Profile',
                        ),
                      ],
                      selectedIndex: navigationController.currentIndex.value,
                      onTabChange: (index) {
                        navigationController.onPageChange(index);
                        _pageController.jumpToPage(index);
                      },
                    ),
                  ),
                ),
              ),
            ));
  }
}
