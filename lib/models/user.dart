import 'dart:core';
import 'dart:developer' as logging;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/services/storage_provider.dart';

import 'login_result.dart';

/// The User class holds all information about the User of the app
/// The class is built to be used as a singleton,
/// so only one instance should be used throughout the app.
class User extends ChangeNotifier {
  final StorageProvider _storage;
  Set<String> _workouts;
  Set<String> _exercises;
  bool _loggedIn;

  /// The name is the name of the user like Thierry
  String name;

  /// The surname is the family name of the user like Odermatt
  String surname;

  /// the URL which points to the profile picture
  String imageURL;

  /// email from the user
  String mail;

  /// Provides an empty User object. This should only be used once at App start.
  User.empty({StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        _loggedIn = false,
        _workouts = <String>{},
        _exercises = <String>{},
        name = '',
        surname = '',
        imageURL = '',
        mail = '' {
    if (_storage.auth.currentUser != null) {
      _loggedIn = true;
      loadDetailsFromLoggedInUser();
    }
  }

  /// Loads the details like nickname, liked objects etc. form the database
  /// After the details are loaded, the listeners are notified
  /// Reruns false if the User is not logged in
  /// or the document referenced by `documentPath` was not found.<br>
  /// If the flag informListeners is set, the listeners will be notified.
  Future<bool> loadDetailsFromLoggedInUser(
      {bool informListeners = true}) async {
    if (!_loggedIn) {
      return false;
    }
    final doc = await _storage.database.doc(documentPath).get();
    if (!doc.exists) {
      logging.log('Loading failed, no doc found');
      return false;
    }
    final map = doc.data();
    logging.log('User attributes from database: ${map.toString()}');
    if (map.containsKey('name') && map['name'] is String) {
      name = map['name'];
    }
    if (map.containsKey('surname') && map['surname'] is String) {
      surname = map['surname'];
    }
    if (map.containsKey('imageURL') && map['imageURL'] is String) {
      imageURL = map['imageURL'];
    }
    if (map.containsKey('workouts') && map['workouts'] is List) {
      _workouts = Set.from(map['workouts']);
    }
    if (map.containsKey('exercises') && map['exercises'] is List) {
      _exercises = Set.from(map['exercises']);
    }
    if (map.containsKey('mail') && map['mail'] is String) {
      mail = map['mail'];
    }
    logging.log('loaded User: ${toString()}');
    if (informListeners) {
      notifyListeners();
    }
    return true;
  }

  ///saves all information from the [User] Class to the database
  ///returns `false` if no user is logged in
  Future<bool> saveUser() async {
    if (!_loggedIn) {
      return false;
    }
    await _storage.database.doc(documentPath).set({
      'name': name,
      'surname': surname,
      'mail': mail,
      'imageURL': imageURL,
      'workouts': _workouts.toList(),
      'exercises': _exercises.toList(),
    });
    return true;
  }

  ///changes any field of the [User].
  ///Afterwards the changes are saved to the database
  ///and the listeners will be informed if the flag [informListeners] is set.
  void updateUserData(
      {String newName,
      String newSurname,
      String newMail,
      String newImageURL,
      String newAddress,
      Set newWorkoutList,
      Set newExerciseList,
      bool informListeners = true}) {
    if (newName != null) name = newName;
    if (newSurname != null) surname = newSurname;
    if (newImageURL != null) imageURL = newImageURL;
    if (newMail != null) mail = newMail;
    if (newWorkoutList != null && newWorkoutList.isNotEmpty) _workouts = newWorkoutList;
    if (newExerciseList != null && newExerciseList.isNotEmpty) _exercises = newExerciseList;
    saveUser();
    if (informListeners) {
      notifyListeners();
    }
  }

  /// is true if the User has confirmed his email address by the sent link
  bool get hasConfirmedEmail =>
      _storage.auth.currentUser != null &&
      _storage.auth.currentUser.emailVerified;

  /// is true if the user is logged in
  bool get isLoggedIn => _loggedIn;

  /// is true if the user is registered with email and password
  bool get isRegisteredWithEmail => isLoggedIn
      ? _storage.auth.currentUser.providerData
          .any((element) => element.providerId == 'password')
      : false;

  /// returns a [String] with the path to the users profile in the database
  String get documentPath => _loggedIn && _storage.auth.currentUser != null
      ? 'users/$userUUID'
      : 'users/anonymous';

  /// returns the UUID of a logged in User
  String get userUUID => _loggedIn ? _storage.auth.currentUser.uid : '';

  /// Adds a workout to the owned workout list
  void addWorkout(Workout workout) {
    if (workout == null || workout.title == null || workout.title.isEmpty) {
      throw ArgumentError('Workout must have a title');
    }
    _workouts.add(workout.title);
    saveUser();
  }

  /// Adds a exercise to the owned exercise list
  void addExercise(Exercise exercise) {
    if (exercise == null || exercise.title == null || exercise.title.isEmpty) {
      throw ArgumentError('Exercise must have a title');
    }
    _exercises.add(exercise.title);
    saveUser();
  }

  void updateExerciseList(String oldName, newName){
    _exercises.remove(oldName);
    _exercises.add(newName);
  }

  /// Returns a list of all names from owned workouts
  List<String> get workouts => _workouts.toList();

  /// Returns a list of all names from owned exercises
  List<String> get exercises => _exercises.toList();

  /// signs the user out, saves all data to the database.
  /// Afterwards all fields are reset to empty fields.
  /// The listeners will be notified
  Future<void> signOut({bool save = true}) async {
    if (_loggedIn) {
      if (save) {
        await saveUser();
      }
      _storage.auth.signOut();
    }
    name = '';
    surname = '';
    imageURL = '';
    mail = '';
    _workouts = <String>{};
    _exercises = <String>{};
    _loggedIn = false;
    notifyListeners();
  }

  @override
  String toString() {
    return '{Name: $name, Surname: $surname}';
  }

  ///Signs the user in with the provided Email and password
  ///if an error occurs returns a [LoginResult] object
  ///with a message as string and a flag isEmailConfirmed which indicates
  ///if the user has already confirmed his email address
  ///<br> if no error occurs null is returned.
  Future<LoginResult> signInWithEmail(String email, String password) async {
    if (!isLoggedIn) {
      try {
        await _storage.auth
            .signInWithEmailAndPassword(email: email, password: password);
        if (_storage.auth.currentUser.emailVerified != null &&
            !_storage.auth.currentUser.emailVerified) {
          _storage.auth.signOut();
          return LoginResult('Bitte bestätigen Sie zuerst ihre Email Adresse',
              isEmailConfirmed: false);
        }
        _loggedIn = true;
        await loadDetailsFromLoggedInUser();
        if (mail.isEmpty && email.isNotEmpty) {
          updateUserData(newMail: email);
        }
      } on FirebaseAuthException catch (error) {
        if (error.code == 'invalid-email') {
          return LoginResult('Die eingegebene Email Adresse ist ungültig.');
        } else if (error.code == 'user-disabled') {
          return LoginResult('Ihr Konto wurde gesperrt. '
              'Bitte wenden Sie sich an den Support.');
        } else {
          return LoginResult('Die Email Adresse oder das Passwort ist falsch');
        }
      }
    }
    return null;
  }

  /// Registers a user with the provided email address and password.
  /// An email will be sent to confirm the users email address.<br>
  /// The User is not logged in afterwards.
  /// Sign in is only possible after the user has confirmed his email address.
  /// <br>returns an error Message which can be displayed if something
  /// goes wrong. Or null if everything is fine.
  Future<String> registerWithEmail(String email, String password,
      {String name, String surname}) async {
    try {
      final cred = await _storage.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      updateUserData(newName: name, newSurname: surname);
      cred.user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        return 'Die eingegebene Email Adresse ist ungültig.';
      } else if (error.code == 'email-already-in-use') {
        return 'Die angegebene Email Adresse wird bereits verwendet.';
      } else if (error.code == 'weak-password') {
        return 'Das angegebene Passwort ist zu schwach. '
            'Ihr Passwort sollte mindestens 6 Zeichen lang sein '
            'und Zahlen sowie Gross- und Kleinbuchstaben beinhalten.';
      } else {
        return 'Something went wrong.';
      }
    }
    return null;
  }

  /// sends the mail to confirm the email address again
  Future<String> sendEmailConfirmation(String email, String password) async {
    try {
      await _storage.auth
          .signInWithEmailAndPassword(email: email, password: password);
      await _storage.auth.currentUser.sendEmailVerification();
      _storage.auth.signOut();
    } on FirebaseAuthException {
      return 'Something went wrong';
    }
    return null;
  }

  /// Sends a password reset link to the provided email.
  Future<bool> sendPasswordResetLink(String email) async {
    final methods = await getSignInMethods(email);
    if (methods.contains('password')) {
      _storage.auth.sendPasswordResetEmail(email: email);
      return true;
    }
    return false;
  }

  /// returns a list of possible sign in methods for the provided email
  Future<List<String>> getSignInMethods(String email) async {
    try {
      var list = await _storage.auth.fetchSignInMethodsForEmail(email);
      return list ??= [];
    } on FirebaseAuthException {
      return [];
    }
  }

  /// change password, can only be used if the user is registered with email and password
  Future<String> changePassword(
      {@required String oldPassword, @required String newPassword}) async {
    if (!isRegisteredWithEmail) {
      return null;
    }
    try {
      await _storage.auth
          .signInWithEmailAndPassword(email: mail, password: oldPassword);
      await _storage.auth.currentUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'weak-password') {
        return 'Das neue Passwort ist zu schwach';
      }
      if (exception.code == 'wrong-password') {
        return 'Das alte Password ist falsch';
      } else {
        return 'Etwas ist schiefgelaufen';
      }
    }
    return null;
  }

  /// Remove a workout from the owned workouts
  void deleteWorkout(Workout workout) {
    _workouts.remove(workout.title);
    saveUser();
    notifyListeners();
  }

  /// Remove a exercise from the owned exercises
  void deleteExercise(Exercise exercise) {
    _exercises.remove(exercise.title);
    saveUser();
    notifyListeners();
  }

  ///Remove a user account.
  Future<String> deleteAccount() async {
    try {
      await _storage.database.doc(documentPath).delete();
      await _storage.auth.currentUser.delete();
      return 'Der Account wurde erfolgreich entfernt';
    } on FirebaseAuthException {
      return 'Etwas ist schiefgelaufen';
    }
  }

  /// ensures the user is authenticated with his email address and password.
  /// Only usable with email Provider<br>
  /// throws: StateError if the user is not registered with email;
  Future<String> reauthenticateWithEmail(String password) async {
    if (!isRegisteredWithEmail) {
      throw StateError(
          'function can only be used with a user which is registered with email and password.');
    }
    if (password == '' || password == null) {
      return 'Bitte gib ein Passwort ein';
    }
    final credential =
        EmailAuthProvider.credential(email: mail, password: password);
    try {
      await FirebaseAuth.instance.currentUser
          .reauthenticateWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'Das Passwort ist falsch';
      } else {
        return 'Etwas ist schiefgelaufen';
      }
    }
  }

  ///Remove a user account.
  Future<String> deleteAccountEmail() async {
    try {
      await _storage.database.doc(documentPath).delete();
      await FirebaseAuth.instance.currentUser.delete();
      return 'Der Account wurde erfolgreich entfernt';
    } on FirebaseAuthException {
      return 'Etwas is schiefgelaufen';
    }
  }
}
