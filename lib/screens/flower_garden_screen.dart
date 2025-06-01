import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowerGardenScreen extends StatelessWidget {
  const FlowerGardenScreen({super.key});

  void _showLoveMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.pink,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.pink,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Soft pastel pink
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          children: [
            // Gül
            _FlowerItem(
              animationPath: 'assets/jsons/flower1.json',
              message: 'Gül kadar zarif bir kalbin var.',
              onTap: () => _showLoveMessage(context, 'Gül kadar zarif bir kalbin var.'),
            ),
            // Papatya
            _FlowerItem(
              animationPath: 'assets/jsons/flower2.json',
              message: 'Papatya gibi saf ve içtensin.',
              onTap: () => _showLoveMessage(context, 'Papatya gibi saf ve içtensin.'),
            ),
            // Kiraz Çiçeği
            _FlowerItem(
              animationPath: 'assets/jsons/flower3.json',
              message: 'Sana bakmak, baharı izlemek gibi.',
              onTap: () => _showLoveMessage(context, 'Sana bakmak, baharı izlemek gibi.'),
            ),
            // Orkide
            _FlowerItem(
              animationPath: 'assets/jsons/flower4.json',
              message: 'Orkide gibi nadide bir varlıksın.',
              onTap: () => _showLoveMessage(context, 'Orkide gibi nadide bir varlıksın.'),
            ),
            // Zambak
            _FlowerItem(
              animationPath: 'assets/jsons/flower5.json',
              message: 'Zambak gibi asil ve güzelsin.',
              onTap: () => _showLoveMessage(context, 'Zambak gibi asil ve güzelsin.'),
            ),
            // Menekşe
            _FlowerItem(
              animationPath: 'assets/jsons/flower6.json',
              message: 'Menekşe gibi mütevazı ve etkileyicisin.',
              onTap: () => _showLoveMessage(context, 'Menekşe gibi mütevazı ve etkileyicisin.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowerItem extends StatelessWidget {
  final String animationPath;
  final String message;
  final VoidCallback onTap;

  const _FlowerItem({
    required this.animationPath,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Lottie.asset(
            animationPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
} 