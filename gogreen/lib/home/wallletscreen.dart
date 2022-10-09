import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gogreen/app_theme.dart';
import 'package:gogreen/home/registrationPage.dart';
import 'package:provider/provider.dart';
import 'package:gogreen/models/user.dart' as model;

import '../constant.dart';
import '../controllers/navigationController.dart';
import '../onboarding/authmethods.dart';
import '../onboarding/firestore_methods.dart';
import '../providers/user_provider.dart';
import '../widget/follow_button.dart';
import '../widget/glassbox.dart';
import '../widget/textField.dart';

class WalletScreen extends StatefulWidget {
  final String uid;
  const WalletScreen({Key key, this.uid}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  var userData = {};

  int coins = 0;
  bool isLoading = false;
  final navigationController = Get.put(NavigationController(), permanent: true);

  TextEditingController amounts = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void addmoney(String uid, int amount) async {
    try {
      String res = await FireStoreMethods().addmoney(
        amount,
        uid,
      );

      if (res != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res),
        ));
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }
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

      // get post lENGTH

      userData = userSnap.data();
      navigationController.coins.value = userSnap.data()['coins'];
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Color.fromRGBO(240, 244, 247, 1),
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                "You have ...",
                                style: TextStyle(
                                    // fontWeight: FontWeight.w900,
                                    color: Color.fromARGB(255, 166, 172,
                                        179) //Color.fromARGB(255, 18, 18, 18),
                                    ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/gogreenlogo.png',
                                    fit: BoxFit.fitHeight,
                                    height: 38,
                                  ),
                                  coincount(navigationController.coins.value),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MaterialButton(
                                height: 40,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 0),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 350,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(0),
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4, 4, 4, 4),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20, 8, 20, 0),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Divider(
                                                            thickness: 3,
                                                            indent: 150,
                                                            endIndent: 150,
                                                            color: Color(
                                                                0xFFDBE2E7),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16,
                                                                        16,
                                                                        16,
                                                                        4),
                                                            child: Container(
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    Text(
                                                                      "Hey there,\nHow many leaves you want to collect?",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            166,
                                                                            172,
                                                                            179),
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          16.0,
                                                                    ),

                                                                    CustomTextField(
                                                                      hint:
                                                                          "Amount",
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .people),
                                                                      obsecure:
                                                                          false,
                                                                      autofocus:
                                                                          false,
                                                                      textController:
                                                                          amounts,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    // AppText(text: "If you don't have a fitbit account, then you'll need to create one first.",color: Colors.black,),
                                                                    GestureDetector(
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                          child: Container(
                                                                              color: Utils.buttonColor.withOpacity(0.6),
                                                                              width: 100,
                                                                              height: 60,
                                                                              padding: EdgeInsets.all(2),
                                                                              child: BackdropFilter(
                                                                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                                                child: Container(
                                                                                    alignment: Alignment.bottomCenter,
                                                                                    child: Container(
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          "Confirm",
                                                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                              )),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          if (navigationController.coins.value >
                                                                              int.parse(amounts.text.trim())) {
                                                                            addmoney(user.uid,
                                                                                int.parse(amounts.text.trim()));
                                                                            Get.back();
                                                                            getData();
                                                                            setState(() {
                                                                              navigationController.coins.value;
                                                                            });
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text("You have Successfully get those leaves  :)"),
                                                                            ));
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text("Please try again :("),
                                                                            ));
                                                                          }
                                                                        })
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Add Money',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 30,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     CircleAvatar(
                          //       backgroundColor: Colors.grey,
                          //       backgroundImage: NetworkImage(
                          //         userData['photoUrl'],
                          //       ),
                          //       radius: 40,
                          //     ),
                          //     Expanded(
                          //       flex: 1,
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             mainAxisSize: MainAxisSize.max,
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceEvenly,
                          //             children: [
                          //               buildStatColumn(postLen, "posts"),
                          //               buildStatColumn(followers, "followers"),
                          //               buildStatColumn(following, "following"),
                          //             ],
                          //           ),
                          //           buildwalletCount(coins, 'coins'),
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceEvenly,
                          //             children: [
                          //               FirebaseAuth.instance.currentUser.uid ==
                          //                       widget.uid
                          //                   ? FollowButton(
                          //                       text: 'Sign Out',
                          //                       backgroundColor: Colors.white,
                          //                       textColor: AppTheme.darkText,
                          //                       borderColor: Colors.grey,
                          //                       function: () async {
                          //                         await AuthMethods().signOut();
                          //                         Get.to(RegstrationPage());
                          //                       },
                          //                     )
                          //                   : isFollowing
                          //                       ? FollowButton(
                          //                           text: 'Unfollow',
                          //                           backgroundColor:
                          //                               Colors.white,
                          //                           textColor: Colors.black,
                          //                           borderColor: Colors.grey,
                          //                           function: () async {
                          //                             await FireStoreMethods()
                          //                                 .followUser(
                          //                               FirebaseAuth.instance
                          //                                   .currentUser.uid,
                          //                               userData['uid'],
                          //                             );

                          //                             setState(() {
                          //                               isFollowing = false;
                          //                               followers--;
                          //                             });
                          //                           },
                          //                         )
                          //                       : FollowButton(
                          //                           text: 'Follow',
                          //                           backgroundColor:
                          //                               Colors.blue,
                          //                           textColor: Colors.white,
                          //                           borderColor: Colors.blue,
                          //                           function: () async {
                          //                             await FireStoreMethods()
                          //                                 .followUser(
                          //                               FirebaseAuth.instance
                          //                                   .currentUser.uid,
                          //                               userData['uid'],
                          //                             );

                          //                             setState(() {
                          //                               isFollowing = true;
                          //                               followers++;
                          //                             });
                          //                           },
                          //                         )
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   padding: const EdgeInsets.only(
                          //     top: 15,
                          //   ),
                          //   child: Text(
                          //     userData['username'],
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   padding: const EdgeInsets.only(
                          //     top: 1,
                          //   ),
                          //   child: Text(
                          //     userData['bio'],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // const Divider(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 40),
                      child: Container(
                        height: 54,
                        width: 54,
                        child: GlassBox(
                          color: Colors.white.withOpacity(0.8),
                          isback: true,
                          child: IconButton(
                            onPressed: () {
                              navigationController.advancedDrawerController
                                  .showDrawer();
                            },
                            icon: const Icon(Icons.menu_rounded),
                            color: Color.fromARGB(255, 85, 92, 100),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Walet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 67, 64, 64),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 40),
                      child: Container(
                        height: 54,
                        width: 54,
                        child: GlassBox(
                          color: Colors.white.withOpacity(0),
                          isback: false,
                          child: IconButton(
                            enableFeedback: false,
                            icon: Icon(
                              Icons.menu_rounded,
                              color: Colors.white.withOpacity(0),
                            ),
                            color: Colors.white.withOpacity(0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Text coincount(int coins) {
    return Text(
      ' $coins',
      style: TextStyle(
        color: Colors.black,
        fontSize: 46,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Row buildwalletCount(int num, String label) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
