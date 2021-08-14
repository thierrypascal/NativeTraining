import 'package:flutter/material.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/account_page/account_page.dart';
import 'package:native_training/pages/exercise_page/create_exercise.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/pages/login_page/login_page.dart';
import 'package:native_training/pages/workout_page/my_workouts_page.dart';
import 'package:provider/provider.dart';

/// The Drawer which is located at the right side of the screen
class MyDrawer extends StatelessWidget {
  /// The Drawer which is located at the right side of the screen,
  /// default constructor
  MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    if (Provider.of<User>(context, listen: false)
                        .isLoggedIn) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountPage()));
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WhiteRedirectPage(
                                'Bitte melde Dich zuerst an', LoginPage())),
                      );
                    }
                  }),
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(children: [
                          ListTile(
                            title: const Text('Meine Trainings'),
                            onTap: () {
                              if (Provider.of<User>(context, listen: false)
                                  .isLoggedIn) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyWorkoutPage()));
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WhiteRedirectPage(
                                          'Bitte melde Dich zuerst an', LoginPage())),
                                );
                              }
                            },
                          ),
                          ListTile(
                            title: const Text('Meine \u00DCbungen'),
                            onTap: () {
                              if (Provider.of<User>(context, listen: false)
                                  .isLoggedIn) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyExercisePage()));
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WhiteRedirectPage(
                                          'Bitte melde Dich zuerst an', LoginPage())),
                                );
                              }
                            },
                          ),
                          Divider(thickness: 2,),
                          ListTile(
                            title: const Text('Neues Training'),
                            onTap: () {},
                          ),
                          ListTile(
                            title: const Text('Neue Übung'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateExercise(
                                        route: MyExercisePage(),
                                      )));
                            },
                          ),
                          Divider(thickness: 2,),
                          _loginLogoutButton(context),
                        ]),
                      ),
                    ],
                  )));
        }),
      ),
    );
  }

  Widget _loginLogoutButton(BuildContext context) {
    if (Provider.of<User>(context).isLoggedIn) {
      return ListTile(
          title: const Text('Logout'), onTap: () => _signOut(context));
    } else {
      return ListTile(
        title: const Text('Login'),
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        ),
      );
    }
  }

  void _signOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ausloggen ?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFC05410)),
                ),
                child: const Text('Abbrechen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<User>(context, listen: false).signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFC05410)),
                ),
                child: const Text('Ausloggen'),
              ),
            ],
          ),
        ));
  }
}
