import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/about_app/view/components/action_buttons_row.dart';
import 'package:quick_pitch_app/features/about_app/view/components/app_header.dart';
import 'package:quick_pitch_app/features/about_app/view/components/app_logo.dart';
import 'package:quick_pitch_app/features/about_app/view/components/info_section.dart';
import 'package:quick_pitch_app/features/about_app/view/widget/app_description_card.dart';
import 'package:quick_pitch_app/features/about_app/view/widget/decorative_wave.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: res.width,
        height: res.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: res.wp(6)),
            child: Column(
              children: [
                SizedBox(height: res.hp(5)),

                AppLogo(res: res),

                SizedBox(height: res.hp(4)),

                AppHeader(res: res),

                SizedBox(height: res.hp(3)),

                AppDescriptionCard(res: res),

                SizedBox(height: res.hp(5)),

                ActionButtonsRow(res: res),

                SizedBox(height: res.hp(5)),

                InfoSection(res: res),

                SizedBox(height: res.hp(4)),

                DecorativeWave(res: res),

                SizedBox(height: res.hp(3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
