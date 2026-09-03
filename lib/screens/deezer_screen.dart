import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dice_game.dart';
import '../models/account_service.dart';

class DeezerScreen extends StatefulWidget {
  const DeezerScreen({super.key});

  @override
  State<DeezerScreen> createState() => _DeezerScreenState();
}

class _DeezerScreenState extends State<DeezerScreen> {
  final List<String> accounts = [
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@hotmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@icloud.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@outlook.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@outlook.be\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@wanadoo.fr\ncontraseña : contraseña-aqui',
    'Correo : ftu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@hotmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-deezer-aqui@hexud.com\ncontraseña : contraseña-aqui',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final service = AccountService(
          prefix: 'deezer',
          accounts: accounts,
          prefs: snapshot.data!,
        );
        return DiceGame(
          service: service,
          title: 'Cuentas Deezer',
          subtitle: 'Lanza el dado. Si sacas un 6, ganas una cuenta.',
        );
      },
    );
  }
}