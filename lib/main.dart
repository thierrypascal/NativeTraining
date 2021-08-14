import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:native_training/pages/login_page/login_page.dart';
import 'package:native_training/pages/workout_page/my_workouts_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong", textDirection: TextDirection.ltr);
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          ServiceProvider.instance;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => User.empty(),
                lazy: false,
              ),
            ],
            child: MaterialApp(
              title: 'NativeTraining',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: auth.FirebaseAuth.instance.currentUser != null
                  ? MyWorkoutPage()
                  : LoginPage(),
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
