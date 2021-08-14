import 'dart:core';
import 'dart:developer' as logging;

import 'package:flutter/cupertino.dart';
import 'package:native_training/services/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Exercise extends ChangeNotifier {
  ///Title of the exercise
  String title;
  ///Description of the exercise
  String description;
  ///ImageURL of the exercise
  String imageURL;
  ///Owner of the exercise
  String owner;
  /// reference where the object is stored in the database
  DocumentReference reference;

  bool _isEmpty;

  final StorageProvider _storage;


  /// creates an empty exercise as placeholder
  Exercise.empty({StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance {
    title = '';
    description = '';
    imageURL = '';
    _isEmpty = true;
  }

  /// creates an exercise from the provided Map.
  /// Used for database loading and testing
  Exercise.fromMap(Map<String, dynamic> map,
      {this.reference, StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        title = map.containsKey('title') ? map['title'] as String : '',
        description = map.containsKey('description') ? map['description'] as String : '',
        imageURL = map.containsKey('imageURL') ? map['imageURL'] as String : '',
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
    });
  }

  /// is true if this exercise is an empty placeholder
  bool get isEmpty => _isEmpty;
}