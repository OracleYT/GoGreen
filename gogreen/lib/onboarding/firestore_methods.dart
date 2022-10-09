import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogreen/onboarding/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    // String profImage
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        // profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addmoney(int coins, String uid) async {
    String res = "Some error occurred";
    try {
      if (coins != 0) {
        DocumentSnapshot currentusersnap =
            await _firestore.collection('users').doc(uid).get();
        await _firestore.collection('users').doc(uid).update({
          'coins': ((currentusersnap.data() as Map<String, dynamic>)['coins'] +
              coins)
        });

        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post transactions
  Future<String> postTransactions(String postId, int coins, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";

    try {
      if (coins != 0) {
        DocumentSnapshot currentusersnap =
            await _firestore.collection('users').doc(uid).get();
        print((currentusersnap.data() as Map<String, dynamic>)['coins']
            .toString());
        await _firestore.collection('users').doc(uid).update({
          'coins': ((currentusersnap.data() as Map<String, dynamic>)['coins'] -
              coins)
        });

        DocumentSnapshot postusersnap =
            await _firestore.collection('posts').doc(postId).get();
        print((postusersnap.data() as Map<String, dynamic>)['uid']);
        DocumentSnapshot postuseridsnap = await _firestore
            .collection('users')
            .doc((postusersnap.data() as Map<String, dynamic>)['uid'])
            .get();
        print((postuseridsnap.data() as Map<String, dynamic>)['coins']
            .toString());
        await _firestore
            .collection('users')
            .doc((postusersnap.data() as Map<String, dynamic>)['uid'])
            .update({
          'coins':
              ((postuseridsnap.data() as Map<String, dynamic>)['coins'] + coins)
        });

        String payementId = const Uuid().v1();

        _firestore
            .collection('posts')
            .doc(postId)
            .collection('transactions')
            .doc(payementId)
            .set({
          // 'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'coins': coins,
          'payementId': payementId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
