import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class AccountService {
  final String prefix;
  final List<String> accounts;
  final SharedPreferences prefs;

  AccountService({required this.prefix, required this.accounts, required this.prefs});

  // Obtener valor de almacenamiento
  dynamic getStorage(String key, dynamic fallback) {
    final fullKey = '${prefix}_$key';
    if (prefs.containsKey(fullKey)) {
      return prefs.get(fullKey);
    }
    return fallback;
  }

  // Guardar valor en almacenamiento
  Future<void> setStorage(String key, dynamic value) async {
    final fullKey = '${prefix}_$key';
    if (value is int) {
      await prefs.setInt(fullKey, value);
    } else if (value is String) {
      await prefs.setString(fullKey, value);
    } else if (value is bool) {
      await prefs.setBool(fullKey, value);
    } else if (value is double) {
      await prefs.setDouble(fullKey, value);
    }
  }

  // Eliminar clave del almacenamiento
  Future<void> removeStorage(String key) async {
    final fullKey = '${prefix}_$key';
    await prefs.remove(fullKey);
  }

  // Obtener cooldown
  int getCooldownUntil() {
    return getStorage('cooldownUntil', 0);
  }

  // Obtener penalización
  int getPenalty() {
    return getStorage('penalty', 0);
  }

  // Obtener intentos restantes
  int getAttempts() {
    return getStorage('attempts', 3);
  }

  // ✅ Reiniciar cooldown - SOLO se usa cuando GANA
  Future<void> resetCooldown() async {
    await removeStorage('cooldownUntil');
    await removeStorage('penalty');
    await removeStorage('attempts');
    // Establecer valores por defecto
    await setStorage('attempts', 3);
    await setStorage('penalty', 0);
  }

  // Iniciar cooldown (cuando pierde 3 veces)
  Future<void> startCooldown(int minutes) async {
    final until = DateTime.now().millisecondsSinceEpoch + (minutes * 60 * 1000);
    await setStorage('cooldownUntil', until);
  }

  // Obtener cuenta aleatoria
  String getRandomAccount() {
    final random = Random();
    return accounts[random.nextInt(accounts.length)];
  }

  // Lanzar dado
  int rollDice() {
    return Random().nextInt(6) + 1;
  }

  // Verificar si está en cooldown
  bool isOnCooldown() {
    final until = getCooldownUntil();
    if (until == 0) return false;
    return DateTime.now().millisecondsSinceEpoch < until;
  }

  // Obtener tiempo restante de cooldown
  Duration getCooldownRemaining() {
    final until = getCooldownUntil();
    if (until == 0) return Duration.zero;
    final remaining = until - DateTime.now().millisecondsSinceEpoch;
    if (remaining <= 0) return Duration.zero;
    return Duration(milliseconds: remaining);
  }
}