import 'dart:core';
import 'dart:developer' as logging;

import 'package:flutter/cupertino.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/information_object.dart';
import 'package:native_training/services/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Workout extends ChangeNotifier implements InformationObject{
  /// reference to the associated User
  String owner;

  ///Title of the workout
  @override
  String title;
  ///Description of the workout
  @override
  String description;
  ///how long the workout lasts/estimation by user
  @override
  int workoutDurationInMinutes;
  ///ImageURL of the exercise
  @override
  String get imageURL => null;

  ///dateTime of when this workout was last used
  DateTime lastUsed;
  ///List of exercises for warm-up
  List<Exercise> warmupExercises;
  ///List of exercises for workout
  List<Exercise> workoutExercises;
  ///List of exercises for cooldown
  List<Exercise> cooldownExercises;
  /// reference where the object is stored in the database
  DocumentReference reference;
  /// which [Workout] are contained in this workout
  Map<String, int> ownedObjects;

  bool _isEmpty;

  final StorageProvider _storage;


  /// creates an empty workout as placeholder
  Workout.empty({StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance {
    title = '';
    workoutDurationInMinutes = 0;
    lastUsed = DateTime.now();
    warmupExercises = [];
    workoutExercises = [];
    cooldownExercises = [];
    _isEmpty = true;
  }

  /// creates an workout from the provided Map.
  /// Used for database loading and testing
  Workout.fromMap(Map<String, dynamic> map,
      {this.reference, StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        title = map.containsKey('title') ? map['title'] as String : '',
        workoutDurationInMinutes = map.containsKey('time') ? map['time'] as int : 0,
        lastUsed = map.containsKey('lastUsed') ? map['lastUsed'] as DateTime : DateTime.now(),
        warmupExercises = map.containsKey('warmupExercises') ? map['warmupExercises'] as List<Exercise> : [],
        workoutExercises = map.containsKey('workoutExercises') ? map['workoutExercises'] as List<Exercise> : [],
        cooldownExercises = map.containsKey('cooldownExercises') ? map['cooldownExercises'] as List<Exercise> : [],
        _isEmpty = false;

  /// loads an workout form a database snapshot
  Workout.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// saves the workout object to the database
  /// any information already present on the database will be overridden
  Future<void> saveWorkout() async {
    logging.log('Save workout $title');
    if (_isEmpty || reference == null) {
      reference = _storage.database.doc('workouts/${Uuid().v4()}');
      _isEmpty = false;
    }
    final path = reference.path;
    await _storage.database.doc(path).set({
      'title': title,
      'time': workoutDurationInMinutes,
      'lastUsed': lastUsed,
      'warmupExercises': warmupExercises,
      'workoutExercises': workoutExercises,
      'cooldownExercises': cooldownExercises,
      'owner': owner,
    });
  }

  /// is true if this workout is an empty placeholder
  bool get isEmpty => _isEmpty;

}