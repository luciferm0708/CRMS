import 'package:flutter/material.dart';
import 'package:particles_fly/particles_fly.dart';
import '../../components/selection_tile.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String selectedPlan = 'monthly';

  void _subscribe(BuildContext context) {
    String planText = selectedPlan == 'monthly' ? "Monthly (Tk. 1500)" : "Yearly (Tk. 15000)";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscription successful! You chose $planText plan.'),
        backgroundColor: const Color(0xFF5C8D89),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const Color primaryColor = Color(0xFF5C8D89);
    const Color secondaryColor = Color(0xFF445A67);
    const Color backgroundColor = Color(0xFF121212);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Go Premium"),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: secondaryColor),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ParticlesFly(
              height: size.height,
              width: size.width,
              connectDots: true,
              numberOfParticles: 50,
              hoverColor: primaryColor.withOpacity(0.2),
              lineColor: primaryColor.withOpacity(0.1),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text("Premium Features",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                    )),
                const SizedBox(height: 30),
                _buildFeatureTile(Icons.assignment_turned_in, "Priority Case Handling", "Get your cases processed faster.", primaryColor),
                _buildFeatureTile(Icons.people_alt, "Legal Consultancy Access", "Access expert legal advice quickly.", primaryColor),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text("Choose your plan",
                          style: TextStyle(
                            fontSize: 20,
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 20),
                      MySelectionTile(
                        title: "Monthly - Tk. 1000",
                        value: "monthly",
                        groupValue: selectedPlan,
                        onChanged: (value) {
                          setState(() => selectedPlan = value!);
                        },
                        height: 80,
                        width: 300,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        borderColor: primaryColor,
                        textColor: const Color(0xFF2D4059),
                      ),
                      MySelectionTile(
                        title: "Yearly - Tk. 10000",
                        value: "yearly",
                        groupValue: selectedPlan,
                        onChanged: (value) {
                          setState(() => selectedPlan = value!);
                        },
                        height: 80,
                        width: 300,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        borderColor: primaryColor,
                        textColor: const Color(0xFF2D4059),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Color(0xFF000080),
                            width: 2.5,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _subscribe(context),
                        child: const Text("Subscribe", style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
      title: Text(title,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF2D4059),
            fontWeight: FontWeight.w500,
          )),
      subtitle: const Text(
        "Access expert legal advice quickly.",
        style: TextStyle(color: Color(0xFF6D7D8B)),
      ),
    );
  }
}
