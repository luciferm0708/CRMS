import 'package:crime_record_management_system/pages/logInInterface.dart';
import 'package:crime_record_management_system/pages/professionals/profPreferences/current_professionals.dart';
import 'package:crime_record_management_system/pages/professionals/profPreferences/professional_preference.dart';
import 'package:flutter/material.dart';
import 'package:particles_fly/particles_fly.dart';

import '../model/professional.dart';

class Profprofilefragmentscreen extends StatefulWidget {
  const Profprofilefragmentscreen({super.key});

  @override
  State<Profprofilefragmentscreen> createState() => _ProfprofilefragmentscreenState();
}

class _ProfprofilefragmentscreenState extends State<Profprofilefragmentscreen> {
  
  final currentProfessional = CurrentProfessional();
  
  void initState() {
    super.initState();
    currentProfessional.getProfessionalInfo();
  }

  void logOutProfessional(BuildContext context) async {
    final resultRes = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              "Log Out",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: const Text(
              "Are you sure?\n You want to log out from the Dollars+?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop("loggedOut");
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        }
    );

    if (resultRes == "loggedOut") {
      await ProfessionalPref.removeProfessionalInfo();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Logininterface()),
            (Route<dynamic> route) => false,
      );
    }
  }
  //nisa
  Widget profInfoItemProfile(IconData iconData, String profData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 16,),
          Expanded(
              child: Text(
                profData,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<Professional>(
        valueListenable: currentProfessional.currentProfessional,
        builder: (context, professional, child) {
          if (professional.username.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              Positioned.fill(
                child: ParticlesFly(
                  height: size.height,
                  width: size.width,
                  connectDots: true,
                  numberOfParticles: 50,
                ),
              ),
              ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  SizedBox(height: size.height * 0.1),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.person, professional.username),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.email, professional.email),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.perm_identity, professional.nidNumber?.toString() ?? ''),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.date_range, professional.organizationName ?? ''),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.date_range, professional.licenseNumber ?? ''),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.date_range, professional.professionType),
                      const SizedBox(height: 20),
                      Center(
                        child: Material(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              logOutProfessional(context);
                            },
                            borderRadius: BorderRadius.circular(32),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              child: Text(
                                "Log Out",
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
