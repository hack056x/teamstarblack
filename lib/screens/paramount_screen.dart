import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dice_game.dart';
import '../models/account_service.dart';

class ParamountScreen extends StatefulWidget {
  const ParamountScreen({super.key});

  @override
  State<ParamountScreen> createState() => _ParamountScreenState();
}

class _ParamountScreenState extends State<ParamountScreen> {
  static const String _accountsUrl =
      'https://raw.githubusercontent.com/hacker056x/cuenta/refs/heads/main/paramount.txt';

  late Future<List<String>> _accountsFuture;

  @override
  void initState() {
    super.initState();
    _accountsFuture = _fetchAccounts();
  }

  Future<List<String>> _fetchAccounts() async {
    final response = await http.get(Uri.parse(_accountsUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar las cuentas (código ${response.statusCode})',
      );
    }

    final lines = const LineSplitter()
        .convert(response.body)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return lines.map((line) {
      // El formato del archivo es: correo:contraseña
      final parts = line.split(':');
      if (parts.length >= 2) {
        final email = parts[0].trim();
        final password = parts.sublist(1).join(':').trim();
        return 'Correo : $email\ncontraseña : $password';
      }
      return line;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object?>>(
      future: Future.wait([
        _accountsFuture,
        SharedPreferences.getInstance(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.cyan,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cuentas Paramount+'),
              backgroundColor: Colors.black,
              foregroundColor: Colors.cyan,
            ),
            backgroundColor: Colors.black,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'No se pudieron cargar las cuentas.\nEl Vecino Te Corto El Internet',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _accountsFuture = _fetchAccounts();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final accounts = snapshot.data![0] as List<String>;
        final prefs = snapshot.data![1] as SharedPreferences;

        if (accounts.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'No hay cuentas disponibles.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final service = AccountService(
          prefix: 'paramount',
          accounts: accounts,
          prefs: prefs,
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
