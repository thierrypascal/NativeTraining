/// this interface defines the common access points for information objects
/// such as Workouts or Exercises.
/// With the help of this interface, every Widget which displays information
/// about a specific thing can be used with different classes
abstract class InformationObject {
  /// returns the title or name of the object
  String get title;

  /// returns a brief description what this element can do
  String get description;

  /// returns how much time this object needs
  int get time;

  /// returns which type of object this is
  String get type;

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
