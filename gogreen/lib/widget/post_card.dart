import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gogreen/app_theme.dart';
import 'package:gogreen/home/comments_screen.dart';
import 'package:gogreen/models/user.dart' as model;
import 'package:gogreen/providers/user_provider.dart';
import 'package:gogreen/widget/glassbox.dart';
import 'package:gogreen/widget/textField.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../models/user.dart';
import '../onboarding/firestore_methods.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key key,
    this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  TextEditingController amounts = TextEditingController();
  int donationlen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchtransactionlen();
  }

  void postpayement(
      String uid, String name, String profilePic, int amount) async {
    try {
      String res = await FireStoreMethods().postTransactions(
        widget.snap['postId'],
        amount,
        uid,
        name,
        profilePic,
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

  fetchtransactionlen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('transactions')
          .get();
      donationlen = snap.docs.length;
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onDoubleTap: () {
        // Fluttertoast.showToast(
        //     msg: "You have Successfully Gifted  :)",
        //     backgroundColor: Colors.grey,
        //     gravity: ToastGravity.CENTER);
        FireStoreMethods().likePost(
          widget.snap['postId'].toString(),
          user.uid,
          widget.snap['likes'],
        );
        setState(() {
          isLikeAnimating = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 221, 224, 227),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(30),
              // color: Colors.black87,
              image: DecorationImage(
                  image: NetworkImage(
                    widget.snap['postUrl'].toString(),
                  ),
                  fit: BoxFit.cover),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //     color: Color.fromARGB(255, 28, 53, 60).withOpacity(0.6)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GlassBox(
                        isback: true,
                        color: Colors.black.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 16,
                                backgroundImage:
                                    AssetImage("images/gogreenlogo.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.snap['username'].toString(),
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 221, 224, 227),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.snap['isgreen'] == true
                                          ? "Green"
                                          : "Donor",
                                      style: TextStyle(
                                          fontSize: 12,
                                          // fontWeight: FontWeight.w900,
                                          color: Color.fromARGB(255, 166, 172,
                                              179) //Color.fromARGB(255, 18, 18, 18),
                                          ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      widget.snap['uid'].toString() == user.uid
                          ? GlassBox(
                              color: Colors.white.withOpacity(0.9),
                              isback: false,
                              child: IconButton(
                                onPressed: () {
                                  deletePost(
                                    widget.snap['postId'].toString(),
                                  );
                                },
                                icon: const Icon(FontAwesomeIcons.remove),
                                color: Color.fromARGB(255, 85, 92, 100),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      ' ${widget.snap['description']}',
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: GlassBox(
                        color: Colors.white.withOpacity(0.9),
                        isback: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LikeAnimation(
                              isAnimating:
                                  widget.snap['likes'].contains(user.uid),
                              smallLike: true,
                              child: IconButton(
                                icon: widget.snap['likes'].contains(user.uid)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                      ),
                                onPressed: () => FireStoreMethods().likePost(
                                  widget.snap['postId'].toString(),
                                  user.uid,
                                  widget.snap['likes'],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: DefaultTextStyle(
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(fontWeight: FontWeight.w800),
                                  child: Text(
                                    '${widget.snap['likes'].length}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        child: Text(
                          donationlen == 0
                              ? ""
                              : '   They have recieved $donationlen gifts :)',
                          style: TextStyle(
                            fontSize: 16,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.2, 0.2),
                                blurRadius: 8.0,
                                color: Color.fromARGB(255, 44, 45, 47),
                              ),
                              Shadow(
                                offset: Offset(0.2, 0.2),
                                blurRadius: 10.0,
                                color: Color.fromARGB(255, 94, 96, 100),
                              ),
                            ],
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      onTap: (() => Get.to(CommentsScreen(
                            postId: widget.snap['postId'].toString(),
                          ))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        coincard(
                            bgcolor: Colors.white.withOpacity(0.9), amount: 5),
                        coincard(
                            bgcolor: Colors.white.withOpacity(0.9), amount: 10),
                        coincard(
                            bgcolor: Colors.white.withOpacity(0.9), amount: 50),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GlassBox(
                        color: Colors.white.withOpacity(0.9),
                        isback: false,
                        child: IconButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
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
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4, 4, 4, 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 8, 20, 0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Divider(
                                                      thickness: 3,
                                                      indent: 150,
                                                      endIndent: 150,
                                                      color: Color(0xFFDBE2E7),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(16, 16,
                                                                  16, 4),
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
                                                            children: <Widget>[
                                                              SizedBox(
                                                                height: 16,
                                                              ),
                                                              Text(
                                                                "Hey there,\nHow many leaves you want to gift?",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          166,
                                                                          172,
                                                                          179),
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 16.0,
                                                              ),
                                                              CustomTextField(
                                                                hint: "Amount",
                                                                icon: const Icon(
                                                                    Icons
                                                                        .people),
                                                                obsecure: false,
                                                                autofocus:
                                                                    false,
                                                                textController:
                                                                    amounts,
                                                              ),
                                                              SizedBox(
                                                                height: 16,
                                                              ),
                                                              GestureDetector(
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    child: Container(
                                                                        color: Utils.buttonColor.withOpacity(0.6),
                                                                        width: 100,
                                                                        height: 60,
                                                                        padding: EdgeInsets.all(2),
                                                                        child: BackdropFilter(
                                                                          filter: ImageFilter.blur(
                                                                              sigmaX: 10,
                                                                              sigmaY: 10),
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
                                                                  onTap: () {
                                                                    if (user.coins >
                                                                        int.parse(amounts
                                                                            .text
                                                                            .trim())) {
                                                                      postpayement(
                                                                          user
                                                                              .uid,
                                                                          user
                                                                              .username,
                                                                          user
                                                                              .photoUrl,
                                                                          int.parse(amounts
                                                                              .text
                                                                              .trim()));

                                                                      Get.back();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("Yeahhh... You gifted ${amounts.text} leaves :)")));
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content:
                                                                            Text("You Don't have enough leaves to gift :("),
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
                          icon: const Icon(FontAwesomeIcons.add),
                          color: Color.fromARGB(255, 85, 92, 100),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              isAnimating: isLikeAnimating,
              child: Icon(
                Icons.favorite,
                color: Colors.white.withOpacity(0.9),
                size: 100,
              ),
              duration: const Duration(
                milliseconds: 400,
              ),
              onEnd: () {
                setState(() {
                  isLikeAnimating = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget coincard({
    Color bgcolor,
    int amount,
    final snap,
  }) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: GlassBox(
        color: bgcolor,
        isback: false,
        child: TextButton.icon(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
            EdgeInsets.only(left: 8.0, right: 8),
          )),
          label: Text(
            " $amount ",
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 85, 92, 100)),
          ),
          icon: Image.asset(
            'images/gogreenlogo.png',
            fit: BoxFit.fitHeight,
            height: 16,
          ),
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                      padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Divider(
                                      thickness: 3,
                                      indent: 150,
                                      endIndent: 150,
                                      color: Color(0xFFDBE2E7),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 16, 16, 4),
                                      child: Container(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Image.asset(
                                                  "images/gogreenlogo.png",
                                                  height: 90,
                                                ),
                                              ),
                                              // AppText(
                                              //   text: title,
                                              //   color: MyColors.resolveCompanyCOlour(),
                                              //   textAlign: TextAlign.center,
                                              //   fontSize: 22,
                                              //   fontWeight: FontWeight.bold,
                                              // ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "You're gifting $amount to " +
                                                    widget.snap['username'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 24.0,
                                              ),
                                              // AppText(text: "If you don't have a fitbit account, then you'll need to create one first.",color: Colors.black,),
                                              GestureDetector(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Container(
                                                        color: Utils.buttonColor
                                                            .withOpacity(0.6),
                                                        width: 100,
                                                        height: 60,
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Container(
                                                                child: Center(
                                                                  child: Text(
                                                                    "Confirm",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              )),
                                                        )),
                                                  ),
                                                  onTap: () {
                                                    if (user.coins > amount) {
                                                      postpayement(
                                                          user.uid,
                                                          user.username,
                                                          user.photoUrl,
                                                          amount);
                                                      Get.back();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            "You have Successfully Gifted $amount :)"),
                                                      ));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            "You Don't have enough leaves to gift :("),
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

          // postpayement(user.uid, user.username, user.photoUrl, amount);
        ),
      ),
    );
  }
}
