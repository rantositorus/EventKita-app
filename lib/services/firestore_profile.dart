import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProfile {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(String userId, Map<String, dynamic> profileData) async {
    try {
      // Add a default profile picture from an asset directory
      profileData['profilePicture'] = 'assets/images/default_profile.png';
      await _firestore.collection('users').doc(userId).set(profileData);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> profileData) async {
    try {
      await _firestore.collection('users').doc(userId).update(profileData);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }
  
}