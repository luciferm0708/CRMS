import 'package:flutter/material.dart';
import 'package:particles_fly/particles_fly.dart';

class BackGround extends StatelessWidget {
  final Widget child;

  const BackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Updated background color
          Container(
            color: const Color(0xFF121212), // Dark neutral base
          ),
          ParticlesFly(
            height: size.height,
            width: size.width,
            connectDots: true,
            hoverColor: Colors.white.withOpacity(0.1), // Subtle particles
            lineColor: Colors.white.withOpacity(0.05), // Faint connections
            numberOfParticles: 50,
          ),
          Center(child: child),
        ],
      ),
    );
  }
}