/// this interface defines the common access points for information objects
/// such as Workouts or Exercises.
/// With the help of this interface, every Widget which displays information
/// about a specific thing can be used with different classes
abstract class InformationObject {
  ///Title of the exercise
  String title;
  ///Description of the exercise
  String description;
  ///how long the workout lasts/estimation by user
  int time;
  ///ImageURL of the exercise
  String imageURL;

  /// returns a map of linked informationObjects
  /// formatted like this:
  /// ```
  /// {
  ///   'a title to display': [item1, item2],
  ///   'another title': [item4, item5, etc...]
  /// }
  /// ```
  Map<String, Iterable<InformationObject>> get associationMap;
}
