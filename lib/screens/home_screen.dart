import 'package:flutter/material.dart';
import 'deezer_screen.dart';
import 'flujotv_screen.dart';
import 'vix_screen.dart';
import 'paramount_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Team Starblack',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                    shadows: [
                      Shadow(blurRadius: 10, color: Colors.cyan),
                      Shadow(blurRadius: 20, color: Colors.cyan),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    _buildMenuButton(
                      context,
                      'Cuenta VIX',
                      Colors.purple,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VixScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      'Cuenta Deezer',
                      Colors.blue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeezerScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      'Cuenta Flujo TV',
                      Colors.green,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FlujoTvScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      'Cuenta Paramount+',
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParamountScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Creado por @hacker056',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Totalmente Gratis',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: Colors.cyan,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}