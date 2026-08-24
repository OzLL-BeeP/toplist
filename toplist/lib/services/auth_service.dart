import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user exists in Firestore
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user: $e');
      return false;
    }
  }

  // Get user model
  Future<UserModel?> getUserModel(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user model: $e');
      return null;
    }
  }

  // Create new user in Firestore
  Future<UserModel?> createUser({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      // Generate unique username from email
      String username = email.split('@')[0].toLowerCase();
      
      // Check if username exists, if so add random number
      bool usernameExists = true;
      String finalUsername = username;
      int counter = 0;
      
      while (usernameExists) {
        final userDoc = await _firestore
            .collection('users')
            .where('username', isEqualTo: finalUsername)
            .get();
        
        if (userDoc.docs.isEmpty) {
          usernameExists = false;
        } else {
          counter++;
          finalUsername = '$username$counter';
        }
      }

      final user = UserModel(
        uid: uid,
        username: finalUsername,
        displayName: displayName,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(user.toJson());
      return user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User cancelled the login
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        // Check if user already exists
        bool exists = await userExists(user.uid);

        if (!exists) {
          // Create new user
          return await createUser(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? 'User',
            photoUrl: user.photoURL,
          );
        } else {
          // Return existing user
          return await getUserModel(user.uid);
        }
      }

      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? bio,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['displayName'] = displayName;
      if (bio != null) updates['bio'] = bio;

      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  // Update user tier
  Future<void> updateUserTier({
    required String uid,
    required String tier,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'tier': tier,
      });
    } catch (e) {
      print('Error updating user tier: $e');
    }
  }

  // Follow user
  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      // Add to current user's following list
      await _firestore.collection('users').doc(currentUserId).update({
        'followingList': FieldValue.arrayUnion([targetUserId]),
        'following': FieldValue.increment(1),
      });

      // Add to target user's followers list
      await _firestore.collection('users').doc(targetUserId).update({
        'followersList': FieldValue.arrayUnion([currentUserId]),
        'followers': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error following user: $e');
    }
  }

  // Unfollow user
  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      // Remove from current user's following list
      await _firestore.collection('users').doc(currentUserId).update({
        'followingList': FieldValue.arrayRemove([targetUserId]),
        'following': FieldValue.increment(-1),
      });

      // Remove from target user's followers list
      await _firestore.collection('users').doc(targetUserId).update({
        'followersList': FieldValue.arrayRemove([currentUserId]),
        'followers': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error unfollowing user: $e');
    }
  }
}
