import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gogreen/app_theme.dart';
import 'package:gogreen/home/add_post_screen.dart';
import 'package:gogreen/home/registrationPage.dart';
import 'package:provider/provider.dart';
import 'package:gogreen/models/user.dart' as model;

import '../controllers/navigationController.dart';
import '../onboarding/authmethods.dart';
import '../onboarding/firestore_methods.dart';
import '../providers/user_provider.dart';
import '../widget/follow_button.dart';
import '../widget/glassbox.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key key, this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  int coins = 0;
  bool isFollowing = false;
  bool isLoading = false;

  final navigationController = Get.put(NavigationController(), permanent: true);

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

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data();
      followers = userSnap.data()['followers'].length;
      following = userSnap.data()['following'].length;
      coins = userSnap.data()['coins'];
      isFollowing = userSnap
          .data()['followers']
          .contains(FirebaseAuth.instance.currentUser.uid);
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
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              "     Hi, " + userData['username'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage("images/gogreenlogo.png"),
                            radius: 50,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildStatColumn(postLen, "buds"),
                                        buildStatColumn(followers, "followers"),
                                        buildStatColumn(following, "following"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 28, vertical: 0),
                            onPressed: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return AddPostScreen();
                                },
                              );
                            },
                            child: Text(
                              'Add Posts',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 1,
                            ),
                            child: Text(
                              userData['bio'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    )
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
                      "Profile",
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

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 18, 18, 18),
            )),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                // fontWeight: FontWeight.w900,
                color: Color.fromARGB(
                    255, 166, 172, 179) //Color.fromARGB(255, 18, 18, 18),
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
        Text(num.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 18, 18, 18),
            )),
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
