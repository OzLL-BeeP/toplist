enum UserTier { free, pro, premium }

class UserModel {
  final String uid;
  final String username;
  final String displayName;
  final String? photoUrl;
  final String? bio;
  final UserTier tier;
  final int followers;
  final int following;
  final DateTime createdAt;
  final int chatBubbleColors; // 1=default, 2=pro, 3=premium, 5=admin
  final bool isAdmin;
  final List<String> followingList;
  final List<String> followersList;

  UserModel({
    required this.uid,
    required this.username,
    required this.displayName,
    this.photoUrl,
    this.bio,
    this.tier = UserTier.free,
    this.followers = 0,
    this.following = 0,
    required this.createdAt,
    this.chatBubbleColors = 1,
    this.isAdmin = false,
    this.followingList = const [],
    this.followersList = const [],
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'tier': tier.name,
      'followers': followers,
      'following': following,
      'createdAt': createdAt.toIso8601String(),
      'chatBubbleColors': chatBubbleColors,
      'isAdmin': isAdmin,
      'followingList': followingList,
      'followersList': followersList,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      tier: UserTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => UserTier.free,
      ),
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      chatBubbleColors: json['chatBubbleColors'] ?? 1,
      isAdmin: json['isAdmin'] ?? false,
      followingList: List<String>.from(json['followingList'] ?? []),
      followersList: List<String>.from(json['followersList'] ?? []),
    );
  }

  // Copy with modifications
  UserModel copyWith({
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    UserTier? tier,
    int? followers,
    int? following,
    int? chatBubbleColors,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      tier: tier ?? this.tier,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt,
      chatBubbleColors: chatBubbleColors ?? this.chatBubbleColors,
      isAdmin: isAdmin ?? this.isAdmin,
      followingList: followingList,
      followersList: followersList,
    );
  }
}
