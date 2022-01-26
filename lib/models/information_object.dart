/// this interface defines the common access points for information objects
/// such as Workouts or Exercises.
/// With the help of this interface, every Widget which displays information
/// about a specific thing can be used with different classes
abstract class InformationObject {
  ///Title of the exercise
  String get title;
  ///Description of the exercise
  String get description;
  ///ImageURL of the exercise
  String get imageURL;
}
