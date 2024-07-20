import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../navBar/bottomnav.dart';
import '../screens/chat_screen.dart';
import '../screens/home_page.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/users_screen.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fullname': fullName,
          'email': email,
          'phone': phone,
          'createdAt': Timestamp.now(),
        });

        return user;
      } else {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User data is null after sign-up.',
        );
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      print('Error in signUp: $e');
      rethrow;
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  void handleAuthError(BuildContext context, FirebaseAuthException e) {
    String message;
    if (e.code == 'wrong-email-or-password') {
      message = 'You have entered an incorrect email or password. Please enter the right email or password to log in to your account';
    } else if (e.code == 'email-already-in-use') {
      message = 'The account already exists for that email.';
    } else if (e.code == 'weak-password') {
      message = 'The password provided is too weak.';
    } else {
      message = 'You have entered an incorrect email or password. Please enter the right email or password to log in to your account';
    }
    Get.snackbar('LogIn Failed', message, backgroundColor: Colors.red, colorText: Colors.white);
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        default:
          message = 'Something went wrong. Please try again later.';
      }
      Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<String?> fetchUserFullName() async {
    try {
      final currentUser = _auth.currentUser!;
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      return userDoc['fullname'];
    } catch (e) {
      print('Error fetching user full name: $e');
      return null;
    }
  }

  String getChatRoomId(String userA, String userB) {
    return userA.hashCode <= userB.hashCode ? '$userA-$userB' : '$userB-$userA';
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String messageText,
    required String senderName,
  }) async {
    try {
      await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add({
        'text': messageText,
        'sender': senderName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  void navigateToChatScreen({
    required String recipientEmail,
    required String recipientFullName,
  }) {
    Get.to(() => ChatScreen(recipientEmail: recipientEmail, recipientFullName: recipientFullName));
  }

  void navigateToHome() {
    Get.off(() => HomePage());
  }

  void navigateToLogin() {
    Get.off(() => LoginScreen());
  }

  void navigateToSignup() {
    Get.off(() => SignupScreen());
  }

  void navigateToUserScreen() {
    Get.off(() => UsersScreen());
  }

  void navigateToNavBarScreen() {
    Get.off(() => const BottomNav());
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      navigateToLogin();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
