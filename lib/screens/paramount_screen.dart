import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dice_game.dart';
import '../models/account_service.dart';

class ParamountScreen extends StatefulWidget {
  const ParamountScreen({super.key});

  @override
  State<ParamountScreen> createState() => _ParamountScreenState();
}

class _ParamountScreenState extends State<ParamountScreen> {
  final List<String> accounts = [
    'Correo : tu-correo-paramount-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-paramount-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-paramount-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-paramount-aqui@gmail.com\ncontraseña : contraseña-aqui',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.cyan,
              ),
            ),
          );
        }
        final service = AccountService(
          prefix: 'paramount',
          accounts: accounts,
          prefs: snapshot.data!,
        );
        return DiceGame(
          service: service,
          title: 'Cuentas Paramount+',
          subtitle: 'Lanza el dado. Si sacas un 6, ganas una cuenta.',
        );
      },
    );
  }
}