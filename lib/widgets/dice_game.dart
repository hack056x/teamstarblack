import 'package:flutter/material.dart';
import 'dart:async';
import '../models/account_service.dart';

class DiceGame extends StatefulWidget {
  final AccountService service;
  final String title;
  final String subtitle;

  const DiceGame({
    super.key,
    required this.service,
    required this.title,
    required this.subtitle,
  });

  @override
  State<DiceGame> createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  bool isLoading = true;
  bool isRolling = false;
  String result = '';
  String account = '';
  String countdownText = '';
  Timer? timer;
  int attempts = 3;
  int penalty = 0;
  bool onCooldown = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void dispose() {
    // ✅ NO cancelamos el timer al salir de la pantalla
    // Solo lo cancelamos si es necesario, pero lo dejamos correr
    super.dispose();
  }

  Future<void> _loadState() async {
    setState(() {
      isLoading = true;
    });

    attempts = widget.service.getAttempts();
    penalty = widget.service.getPenalty();
    onCooldown = widget.service.isOnCooldown();

    if (onCooldown) {
      _startCountdown();
    } else {
      setState(() {
        countdownText = '';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _startCountdown() {
    // Cancelar timer anterior si existe
    timer?.cancel();
    
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Verificar si el widget sigue montado
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      final remaining = widget.service.getCooldownRemaining();
      if (remaining.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          countdownText = '¡Ya puedes lanzar!';
          onCooldown = false;
          attempts = 3;
          penalty = 0;
        });
        widget.service.resetCooldown();
      } else {
        setState(() {
          countdownText =
              'Espera ${remaining.inMinutes}m ${remaining.inSeconds % 60}s...';
        });
      }
    });
  }

  // ✅ Función para reiniciar SOLO cuando se gana
  Future<void> _resetOnWin() async {
    // Cancelar el timer actual
    timer?.cancel();
    timer = null;
    
    // Limpiar el estado
    setState(() {
      countdownText = '';
      onCooldown = false;
      attempts = 3;
      penalty = 0;
    });
    
    // Reiniciar el almacenamiento
    await widget.service.resetCooldown();
  }

  Future<void> _rollDice() async {
    if (isRolling || onCooldown) return;

    setState(() {
      isRolling = true;
      result = '🎲 Tirando...';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final roll = widget.service.rollDice();
    setState(() {
      result = 'Has sacado un $roll';
    });

    if (roll == 6) {
      // ✅ SOLO AQUÍ se reinicia el contador - cuando GANA
      final accountData = widget.service.getRandomAccount();
      setState(() {
        account = '🎉 ¡Ganaste!\n$accountData';
        isRolling = false;
      });
      
      // Reiniciar todo SOLO al ganar
      await _resetOnWin();
      
    } else {
      setState(() {
        account = '❌ No ganaste esta vez.';
        attempts = attempts - 1;
      });

      if (attempts <= 0) {
        // ❌ 3 fallos - Iniciar cooldown (NO se reinicia el contador)
        penalty = penalty + 5;
        await widget.service.setStorage('penalty', penalty);
        await widget.service.startCooldown(penalty);
        await widget.service.setStorage('attempts', 3);
        setState(() {
          onCooldown = true;
          attempts = 3;
          isRolling = false;
        });
        _startCountdown(); // Iniciar nuevo contador (NO se reinicia, solo se inicia)
      } else {
        await widget.service.setStorage('attempts', attempts);
        setState(() {
          isRolling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.cyan,
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.cyan,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ✅ NO cancelamos el timer al salir
            // Solo navegamos hacia atrás
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                    shadows: [
                      Shadow(blurRadius: 10, color: Colors.cyan),
                      Shadow(blurRadius: 20, color: Colors.cyan),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Totalmente Gratis',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyan.shade100,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                // Botón Dado
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onCooldown ? null : _rollDice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onCooldown ? Colors.grey.shade800 : Colors.cyan,
                      foregroundColor: Colors.black,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(40),
                      elevation: 10,
                      shadowColor: Colors.cyan,
                    ),
                    child: Text(
                      isRolling ? '🎲' : '🎲',
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  onCooldown ? 'Esperando...' : 'Lanzar dado',
                  style: TextStyle(
                    fontSize: 16,
                    color: onCooldown ? Colors.grey : Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Resultado
                if (result.isNotEmpty)
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(height: 10),
                // Cuenta ganada
                if (account.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Text(
                      account,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 10),
                // Countdown
                if (countdownText.isNotEmpty)
                  Text(
                    countdownText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                const Spacer(),
                // Intentos restantes
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan.shade300, width: 0.5),
                  ),
                  child: Text(
                    'Intentos restantes: $attempts',
                    style: TextStyle(
                      fontSize: 14,
                      color: attempts > 0 ? Colors.cyan.shade100 : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Crédito
                Text(
                  'Creado por @hacker056',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.cyan.shade300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}