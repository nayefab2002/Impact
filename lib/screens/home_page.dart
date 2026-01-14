import "package:flutter/material.dart";
import "../widgets/homepage/footer_section.dart";
import "../widgets/homepage/header_section.dart";
import "../widgets/homepage/hero_section.dart";
import "../widgets/homepage/mid_section.dart";
import "../widgets/homepage/tip_explanation_section.dart";


class ImpactHomePage extends StatelessWidget {
  const ImpactHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFF0B0B5A), // Dark Blue Background
      appBar:PreferredSize(preferredSize: Size.fromHeight(90), child: HeaderSection()),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              decoration: BoxDecoration(
                 image: DecorationImage(image: AssetImage("assets/images/impact_1.jpg",),fit: BoxFit.cover)
              ),
              child: Column(
                children: [
                  HeroSection(),
                  MidSection(),
                  TipExplanationSection(),
                ],
              ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}