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
        padding: const EdgeInsets.only(top: 60.0), // Adjust this value to move the content higher
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/crms.png',
              height: 170,
              width: 170,
            ),
            const Text(
              'Crime Report',
              style: TextStyle(
                fontFamily: 'Roboto', // Change to your desired font
                color: Colors.purple,
                fontSize: 20, // Adjusted size for better visibility
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Management System',
              style: TextStyle(
                fontFamily: 'Roboto', // Change to your desired font
                color: Colors.purple,
                fontSize: 20, // Adjusted size for better visibility
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            // Use the custom MyButton
            MyButton(
              text: 'Get Started',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserType()),
                );
              },
              height: 50.0,  // Adjusted height
              width: 200.0,  // Adjusted width
              color: Colors.purpleAccent,  // Custom button color
              borderColor: Colors.deepPurpleAccent,  // Custom border color
            ),
          ],
        ),
      ),
    );
  }
}
