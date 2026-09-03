import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dice_game.dart';
import '../models/account_service.dart';

class VixScreen extends StatefulWidget {
  const VixScreen({super.key});

  @override
  State<VixScreen> createState() => _VixScreenState();
}

class _VixScreenState extends State<VixScreen> {
  final List<String> accounts = [
    'Correo : tu-correo-vix-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-vix-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-vix-aqui@gmail.com\ncontraseña : contraseña-aqui',
    'Correo : tu-correo-vix-aqui@gmail.com\ncontraseña : contraseña-aqui',
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
          prefix: 'vix',
          accounts: accounts,
          prefs: snapshot.data!,
        );
        return DiceGame(
          service: service,
          title: 'Cuentas Vix+',
          subtitle: 'Lanza el dado. Si sacas un 6, ganas una cuenta.',
        );
      },
    );
  }
}