import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gogreen/app_theme.dart';
import 'package:gogreen/home/comments_screen.dart';
import 'package:gogreen/models/user.dart' as model;
import 'package:gogreen/providers/user_provider.dart';
import 'package:gogreen/widget/glassbox.dart';
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
  int commentLen = 0;
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
        SnackBar(content: Text(res));
      }
    } catch (err) {
      SnackBar(content: Text(err.toString()));
    }
  }

  fetchtransactionlen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('transactions')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      SnackBar(content: Text(err.toString()));
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      SnackBar(content: Text(err.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onDoubleTap: () {
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
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  widget.snap['profImage'].toString(),
                                ),
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
                              color: Colors.white,
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
                  height: 120,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GlassBox(
                      color: Colors.white,
                      isback: false,
                      child: LikeAnimation(
                        isAnimating: widget.snap['likes'].contains(user.uid),
                        smallLike: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                      ),
                    ),
                    GlassBox(
                      color: Colors.white,
                      isback: false,
                      child: IconButton(
                          icon: const Icon(FontAwesomeIcons.paperPlane,
                              size: 20,
                              color: Color.fromARGB(255, 85, 92, 100)),
                          onPressed: () {}),
                    ),
                  ],
                ),
                Row(
                  children: [
                    coincard(bgcolor: Colors.white, amount: 5),
                    coincard(bgcolor: Colors.white, amount: 10),
                    coincard(bgcolor: Colors.white, amount: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GlassBox(
                        color: Colors.white,
                        isback: false,
                        child: IconButton(
                          onPressed: () {
                            deletePost(
                              widget.snap['postId'].toString(),
                            );
                          },
                          icon: const Icon(FontAwesomeIcons.add),
                          color: Color.fromARGB(255, 85, 92, 100),
                        ),
                      ),
                    ),
                  ],
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       DefaultTextStyle(
                //           style: Theme.of(context)
                //               .textTheme
                //               .subtitle2
                //               .copyWith(fontWeight: FontWeight.w800),
                //           child: Text(
                //             '${widget.snap['likes'].length} likes',
                //             style: Theme.of(context).textTheme.bodyText2,
                //           )),
                //       Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.only(
                //           top: 8,
                //         ),
                //         child: RichText(
                //           text: TextSpan(
                //             style: const TextStyle(color: AppTheme.darkText),
                //             children: [
                //               TextSpan(
                //                 text: widget.snap['username'].toString(),
                //                 style: const TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               TextSpan(
                //                 text: ' ${widget.snap['description']}',
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       InkWell(
                //         child: Container(
                //           child: Text(
                //             'View all $commentLen comments',
                //             style: const TextStyle(
                //               fontSize: 16,
                //               color: AppTheme.darkText,
                //             ),
                //           ),
                //           padding: const EdgeInsets.symmetric(vertical: 4),
                //         ),
                //         onTap: (() => Get.to(CommentsScreen(
                //               postId: widget.snap['postId'].toString(),
                //             ))),
                //         // onTap: () => Navigator.of(context).push(
                //         //   MaterialPageRoute(
                //         //     builder: (context) => CommentsScreen(
                //         //       postId: widget.snap['postId'].toString(),
                //         //     ),
                //         //   ),
                //         // ),
                //       ),
                //       Container(
                //         child: Text(
                //           DateFormat.yMMMd()
                //               .format(widget.snap['datePublished'].toDate()),
                //           style: const TextStyle(
                //             color: AppTheme.darkText,
                //           ),
                //         ),
                //         padding: const EdgeInsets.symmetric(vertical: 4),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              isAnimating: isLikeAnimating,
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
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
            EdgeInsets.only(left: 6.0, right: 6),
          )),
          label: Text(
            "$amount ",
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
                                                      SnackBar(
                                                          content: Text(
                                                              "You have Successfully Gifted  :)"));
                                                    } else {
                                                      SnackBar(
                                                          content: Text(
                                                              "You Don't have enough leaves to gift :("));
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
