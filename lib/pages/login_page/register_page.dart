import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/screen_with_logo_and_waves.dart';
import 'package:native_training/pages/login_page/register_email_page.dart';

/// On this page you can choose which provider you want to use to register
class RegisterPage extends StatelessWidget {
  /// On this page you can choose which provider you want to use to register
  RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
        textStyle: MaterialStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 22)));

    return LogoAndWavesScreen(
      title: 'Registrieren',
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Registrieren mit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: _buttonStyle,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterEmailPage())),
              child: const Text('E-Mail'),
            ),
          ],
        ),
      ],
    );
  }
}
