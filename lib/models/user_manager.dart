import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:virtual_shop/helpers/firebase_errors.dart';
import 'package:virtual_shop/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  User user;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;

    try {
      final AuthResult _result = await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      await _loadCurrentUser(firebaseUser: _result.user);
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }

    loading = false;
  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async {
    loadingFace = true;

    final result = await FacebookLogin().logIn([
      'email',
      'public_profile',
    ]);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final autResult = await auth.signInWithCredential(credential);

        if (autResult != null) {
          final firebaseUser = autResult.user;

          user = User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
          );

          await user.saveData();
          onSuccess();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }

    loadingFace = false;
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;

    try {
      final AuthResult _result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      user.id = _result.user.uid;
      this.user = user;
      await user.saveData();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }

    loading = false;
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser _currentUser = firebaseUser ?? await auth.currentUser();

    if (_currentUser != null) {
      final DocumentSnapshot docUser =
          await _firestore.collection('users').document(_currentUser.uid).get();
      user = User.fromDocument(docUser);

      final docAdmin =
          await _firestore.collection('admins').document(user.id).get();
      user.admin = docAdmin.exists;

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin;
}
