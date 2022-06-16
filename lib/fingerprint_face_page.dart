// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:biometric_facial_simmple/home.dart';
import 'package:biometric_facial_simmple/local_auth_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'main.dart';

class FingerprintFaceIDPage extends StatelessWidget {
  const FingerprintFaceIDPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Logo(),
                SizedBox(height: 24),
                CheckAvailability(context),
                SizedBox(height: 24),
                TouchID(context),
                SizedBox(height: 24),
                FaceID(context),
              ],
            ),
          ),
        ),
      );


  Widget Logo() => Column(
    children: [
      Text(
        'ID Authentication',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Colors.orange),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16),
      ShaderMask(
        shaderCallback: (bounds) {
          final colors = [Colors.orangeAccent, Colors.pinkAccent];

          return RadialGradient(colors: colors).createShader(bounds);
        },
        child: Icon(Icons.auto_fix_high,
            size: 100, color: Colors.white),
      ),
    ],
  );


  Widget CheckAvailability(BuildContext context) => buildButton(
        text: 'Check Availability',
        icon: Icons.event_available,
        onClicked: () async {
          final isAvailable = await LocalAuthApi.hasBiometrics();
          final biometrics = await LocalAuthApi.getBiometrics();

          final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Availability'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildText('Biometrics', isAvailable),
                  buildText('Fingerprint', hasFingerprint),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
      );


  Widget TouchID(BuildContext context) => buildButton(
        text: 'Touch ID Auth',
        icon: Icons.fingerprint,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          }
        },
      );

  Widget FaceID(BuildContext context) => buildButton(
      text: 'Face ID Auth',
      icon: Icons.tag_faces,
      onClicked: () async {
        final isAuthenticated = await LocalAuthApi.authenticate();

        try {
          if (isAuthenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          } else {}
        } on PlatformException catch (e) {
          if (kDebugMode) {
            print("$e");
          }
        }
      });

  Widget buildText(String text, bool checked) => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        checked
            ? Icon(Icons.check, color: Colors.green, size: 24)
            : Icon(Icons.close, color: Colors.red, size: 24),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 24)),
      ],
    ),
  );


  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );

}
