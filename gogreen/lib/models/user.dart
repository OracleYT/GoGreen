import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final bool isgreen;
  final int coins;

  const User({
    this.username,
    this.uid,
    this.photoUrl = "",
    this.email,
    this.bio,
    this.followers,
    this.following,
    this.isgreen,
    this.coins,
  });
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      isgreen: snapshot["isgreen"],
      coins: snapshot["coins"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "isgreen": isgreen,
        "coins": coins,
      };
}
