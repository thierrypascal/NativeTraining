import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/edit_dialog.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/login_page/login_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

///Delete account
class MyAccountDelete extends StatefulWidget {
  ///Delete account
  MyAccountDelete({Key key}) : super(key: key);

  @override
  _MyAccountDeleteState createState() => _MyAccountDeleteState();
}

class _MyAccountDeleteState extends State<MyAccountDelete> {
  final _formKey = GlobalKey<FormState>();
  bool _password_ok = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return EditDialog(
      title: 'Account löschen',
      abortCallback: () {
        Navigator.pop(context);
      },
      save: 'Löschen',
      saveIcon: Icons.delete_forever,
      saveCallback: _password_ok
          ? () {
              _confirm_delete(context);
            }
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  helperText:
                      'Bitte gib Dein Passwort ein um deinen Account zu löschen',
                  labelText: 'Passwort',
                ),
                onSaved: (password) async {
                  EmailAuthCredential credential = EmailAuthProvider.credential(
                      email: user.mail, password: password);
                  if (password == '') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Bitte gib ein Passwort ein')));
                  } else {
                    try {
                      await FirebaseAuth.instance.currentUser
                          .reauthenticateWithCredential(credential);
                      setState(() {
                        _password_ok = true;
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-password') {
                        _password_ok = false;

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Das Passwort ist falsch')));
                      } else {
                        _password_ok = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Etwas ist schiefgelaufen')));
                      }
                    }
                  }
                }),
          ),
          ElevatedButton(
              onPressed: () => _formKey.currentState.save(),
              child: const Text('Passwort bestätigen')),
        ],
      ),
    );
  }

  void _confirm_delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                  'Willst den Account und all deine Trainings und \u00DCbungen unwiderruflich löschen?'),
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
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFC05410)),
                    ),
                    label: const Text('Löschen'),
                  ),
                ],
              ),
            )).then((value) async {
      if (value != null) {
        //delete all workouts
        ServiceProvider.instance.workoutService.deleteAllWorkoutsFromUser(
            Provider.of<User>(context, listen: false));
        //delete all exercises
        ServiceProvider.instance.exerciseService.deleteAllExercisesFromUser(
            Provider.of<User>(context, listen: false));
        //delete mail
        final res = await Provider.of<User>(context, listen: false)
            .deleteAccountEmail();
        await Provider.of<User>(context, listen: false).signOut(save: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WhiteRedirectPage('$res', LoginPage())),
        );
      }
    });
  }
}
