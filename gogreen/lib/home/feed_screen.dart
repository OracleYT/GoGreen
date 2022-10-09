import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../controllers/navigationController.dart';
import '../widget/glassbox.dart';
import '../widget/post_card.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:instagram_clone_flutter/utils/colors.dart';
// import 'package:instagram_clone_flutter/utils/global_variable.dart';
// import 'package:instagram_clone_flutter/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final navigationController = Get.put(NavigationController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 244, 247, 1),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (ctx, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: index == 0 ? 80 : 8,
                        bottom: 8,
                        left: 22,
                        right: 22),
                    child: PostCard(
                      snap: snapshot.data.docs[index].data(),
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
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
                "Go Green...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 67, 64, 64),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
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
}
