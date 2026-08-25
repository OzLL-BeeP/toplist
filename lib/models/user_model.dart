import 'subscription_model.dart';

class UserModel {
  final String uid;
  final String username;
  final String displayName;
  final String? photoUrl;
  final String? bio;
  final SubscriptionModel subscription;
  final int followers;
  final int following;
  final DateTime createdAt;
  final bool isAdmin;
  final List<String> followingList;
  final List<String> followersList;
  final DateTime? lastUsernameChange;

  UserModel({
    required this.uid,
    required this.username,
    required this.displayName,
    this.photoUrl,
    this.bio,
    SubscriptionModel? subscription,
    this.followers = 0,
    this.following = 0,
    required this.createdAt,
    this.isAdmin = false,
    this.followingList = const [],
    this.followersList = const [],
    this.lastUsernameChange,
  }) : subscription = subscription ?? SubscriptionModel();

  // Badge shown next to this user's name/comments.
  // Derived ONLY from subscription entitlement — never from user input.
  String? get badge => isAdmin ? 'ADMIN' : subscription.badgeLabel;

  bool get canChangeUsername {
    if (lastUsernameChange == null) return true;
    return DateTime.now().difference(lastUsernameChange!).inDays >= 7;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'subscription': subscription.toJson(),
      'followers': followers,
      'following': following,
      'createdAt': createdAt.toIso8601String(),
      'isAdmin': isAdmin,
      'followingList': followingList,
      'followersList': followersList,
      'lastUsernameChange': lastUsernameChange?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      subscription: SubscriptionModel.fromJson(json['subscription']),
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isAdmin: json['isAdmin'] ?? false,
      followingList: List<String>.from(json['followingList'] ?? []),
      followersList: List<String>.from(json['followersList'] ?? []),
      lastUsernameChange: json['lastUsernameChange'] != null
          ? DateTime.tryParse(json['lastUsernameChange'])
          : null,
    );
  }

  UserModel copyWith({
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    SubscriptionModel? subscription,
    int? followers,
    int? following,
    bool? isAdmin,
    DateTime? lastUsernameChange,
  }) {
    return UserModel(
      uid: uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      subscription: subscription ?? this.subscription,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
      followingList: followingList,
      followersList: followersList,
      lastUsernameChange: lastUsernameChange ?? this.lastUsernameChange,
    );
  }
}
