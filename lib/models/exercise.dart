import 'dart:core';
import 'dart:developer' as logging;

import 'package:flutter/cupertino.dart';
import 'package:native_training/models/information_object.dart';
import 'package:native_training/services/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Exercise extends ChangeNotifier implements InformationObject {
  /// reference where the object is stored in the database
  String owner;

  ///Title of the exercise
  @override
  String title;

  ///Description of the exercise
  @override
  String description;

  ///ImageURL of the exercise
  @override
  String imageURL;

  ///The type of the exercise, 0 = undefined, 1 = warmup, 2 = workout, 3 = cooldown
  int type;

  ///Owner of the exercise
  DocumentReference reference;

  bool _isEmpty;

  final StorageProvider _storage;


  /// creates an empty exercise as placeholder
  Exercise.empty({StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance {
    owner = '';
    title = '';
    description = '';
    imageURL = '';
    type = 0;
    _isEmpty = true;
  }

  /// creates an exercise from the provided Map.
  /// Used for database loading and testing
  Exercise.fromMap(Map<String, dynamic> map,
      {this.reference, StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        owner = map.containsKey('owner') ? map['owner'] as String : '',
        title = map.containsKey('title') ? map['title'] as String : '',
        description = map.containsKey('description') ? map['description'] as String : '',
        imageURL = map.containsKey('imageURL') ? map['imageURL'] as String : '',
        type = map.containsKey('type') ? map['type'] as int : 0,
        _isEmpty = false;

  /// loads an exercise form a database snapshot
  Exercise.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// saves the exercise object to the database
  /// any information already present on the database will be overridden
  Future<void> saveExercise() async {
    logging.log('Save exercise $title');
    if (_isEmpty || reference == null) {
      reference = _storage.database.doc('exercises/${Uuid().v4()}');
      _isEmpty = false;
    }
    final path = reference.path;
    await _storage.database.doc(path).set({
      'title': title,
      'description': description,
      'imageURL': imageURL,
      'type': type,
      'owner' : owner,
    });
  }

  /// is true if this exercise is an empty placeholder
  bool get isEmpty => _isEmpty;

  ///converts an exercise to json format
  Map toJson() => {
    'title': title,
    'description': description,
    'imageURL': imageURL,
    'type': type,
    'owner' : owner,
  };
}