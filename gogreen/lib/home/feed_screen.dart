import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 244, 247, 1),
      body: StreamBuilder(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
                child: PostCard(
                  snap: snapshot.data.docs[index].data(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
