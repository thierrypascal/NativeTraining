
import 'package:native_training/services/exercise_service.dart';
import 'package:native_training/services/workout_service.dart';

import 'image_service.dart';

/// A class which provides a single place where all services can be accessed
class ServiceProvider {
  ServiceProvider._privateConstructor();

  //all services
  static final _workoutService = WorkoutService();
  static final _exerciseService = ExerciseService();
  static final _imageService = ImageService();
  static final _instance = ServiceProvider._privateConstructor();

  /// Instance of the ServiceProvider
  static final ServiceProvider instance = _instance;

  //all references
  /// Reference to the WorkoutService
  final WorkoutService workoutService = _workoutService;

  /// Reference to the ExerciseService
  final ExerciseService exerciseService = _exerciseService;

  /// Reference to the ImageService
  final ImageService imageService = _imageService;

}
