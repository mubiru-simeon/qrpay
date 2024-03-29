import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanged => _firebaseAuth.authStateChanges();

//GET USER
  getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // GET UID
  getCurrentUID() {
    return _firebaseAuth.currentUser.uid;
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Update the username
    await updateUserName(username, authResult.user);
    return authResult.user.uid;
  }

  Future updateUserName(String name, User currentUser) async {
    currentUser.updateDisplayName(name.trim());
    await currentUser.reload();
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    ))
        .user
        .uid;
  }

  Future<void> updateProfPic(String profPic) {
    return _firebaseAuth.currentUser.updatePhotoURL(profPic);
  }

  // Sign Out
  signOut() {
    StorageServices().updateLastLogout(
      _firebaseAuth.currentUser.uid,
    );

    StorageServices().removeFCMToken(
      _firebaseAuth.currentUser.uid,
    );

    return _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<UserCredential> googleSignUp(BuildContext context) async {
    GoogleSignInAccount account = await GoogleSignIn().signIn();

    if (account == null) {
      return null;
    } else {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await account.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      return result;
    }
  }

  // Create Anonymous User
  Future signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future convertUserWithEmail(
      String email, String password, String username) async {
    final currentUser = _firebaseAuth.currentUser;

    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(username, currentUser);
  }
}

class UserNameValidator {
  static String validate(String value) {
    if (value.trim().isEmpty) {
      return "UserName can't be empty";
    }
    return null;
  }
}

class PhoneNumberValidator {
  static String validate(String value) {
    if (value.trim().isEmpty) {
      return "Phone number can't be empty";
    }
    return null;
  }
}

class UsernameValidator {
  static String validate(String value) {
    if (value.trim().isEmpty) {
      return "Username can't be empty";
    }
    if (value.trim().length < 2) {
      return "Username must be at least 2 characters long";
    }
    if (value.trim().length > 50) {
      return "Username must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.trim().isEmpty) {
      return "Email can't be empty";
    } else if (!value.trim().contains("@")) {
      return "Please enter a valid Email";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.trim().isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
