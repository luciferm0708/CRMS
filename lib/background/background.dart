import 'package:flutter/material.dart';
import 'package:particles_fly/particles_fly.dart';

class BackGround extends StatelessWidget {
  final Widget child; // Accept a child widget to overlay on the background

  const BackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Black background
          Container(
            color: Colors.black,
          ),
          // White particle effects using ParticlesFly
          Center(
            child: ParticlesFly(
              height: size.height,
              width: size.width,
              connectDots: true,
              numberOfParticles: 50,
            ),
          ),
          // The child widget passed to this background
          Center(child: child), // Overlay the passed widget on the background
        ],
      ),
    );
  }
}
