import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dice_game.dart';
import '../models/account_service.dart';

class FlujoTvScreen extends StatefulWidget {
  const FlujoTvScreen({super.key});

  @override
  State<FlujoTvScreen> createState() => _FlujoTvScreenState();
}

class _FlujoTvScreenState extends State<FlujoTvScreen> {
  final List<String> accounts = [
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
    'usuario : usuario-flujo-aqui\ncontraseña : contraseña-aqui',
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
          prefix: 'flujo',
          accounts: accounts,
          prefs: snapshot.data!,
        );
        return DiceGame(
          service: service,
          title: 'Cuentas Flujo TV',
          subtitle: 'Lanza el dado. Si sacas un 6, ganas una cuenta.',
        );
      },
    );
  }
}