
/// A class which provides a single place where all services can be accessed
class ServiceProvider {
  ServiceProvider._privateConstructor();

  //all services
  static final _instance = ServiceProvider._privateConstructor();

  /// Instance of the ServiceProvider
  static final ServiceProvider instance = _instance;

  //all references

}
