import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class BestWishScreen extends StatelessWidget {
  static final List<String> _wishes = [
    "Her anımız bir şiir gibi, her günümüz bir masal gibi geçsin.",
    "Seninle geçen her gün, kalbimde açan yeni bir çiçek gibi.",
    "Hayallerimiz gökyüzü kadar sonsuz, sevgimiz denizler kadar derin olsun.",
    "Her sabah gözlerimi açtığımda, ilk düşüncem sen ol.",
    "Seninle paylaştığımız her an, zamanın en değerli hediyesi.",
    "Kalbimizin ritmi hiç değişmesin, aşkımız hep ilk günkü gibi taze kalsın.",
    "Mutluluğumuz daim, sevgimiz sonsuz olsun.",
    "Her gülüşün hayatıma kattığın en güzel melodi.",
    "Seninle yaşadığım her an, hayatımın en değerli hazinesi.",
    "Aşkımız zaman geçtikçe daha da güzelleşsin, büyüsün."
  ];

  // Uygulama başladığında bir kere seçilecek dilek
  static final String _currentWish = _wishes[Random().nextInt(_wishes.length)];

  const BestWishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Soft pastel pink
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                "Birlikteliğimiz",
                style: GoogleFonts.dancingScript(
                  fontSize: 36,
                  color: const Color(0xFFBF1E2E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Icon(
                Icons.favorite,
                size: 80,
                color: const Color(0xFFBF1E2E).withOpacity(0.8),
              ),
              const SizedBox(height: 40),
              Text(
                "365",
                style: GoogleFonts.dancingScript(
                  fontSize: 72,
                  color: const Color(0xFFBF1E2E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "senli geçen günlerin sayısı",
                style: GoogleFonts.dancingScript(
                  fontSize: 24,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _currentWish,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    color: const Color(0xFFBF1E2E),
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Araz Guliyev",
                style: GoogleFonts.greatVibes(
                  fontSize: 24,
                  color: const Color(0xFFBF1E2E),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
} 