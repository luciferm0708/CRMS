import 'package:crime_record_management_system/pages/userType.dart';
import 'package:flutter/material.dart';
import '../background/background.dart';
import '../components/button.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/crms.png',
              height: 170,
              width: 170,
            ),
            const Text(
              'Welcome to',
              style: TextStyle(
                color: Color(0xFF2D4059), // Navy blue
                fontSize: 24,
                fontWeight: FontWeight.w500, // Medium weight
              ),
            ),
            const Text(
              'TODONTO',
              style: TextStyle(
                color: Color(0xFF2D4059), // Navy blue
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            MyButton(
              text: 'Get Started',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserType()),
                );
              },
              height: 50.0,
              width: 200.0,
              color: Color(0xFF5C8D89), // Muted teal
              borderColor: Color(0xFF445A67), // Darker teal
            ),
          ],
        ),
      ),
    );
  }
}

