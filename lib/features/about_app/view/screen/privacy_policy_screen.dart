import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/about_app/view/components/policy_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF667EEA),
        title: Text(
          'Privacy Policy',
          style: TextStyle(fontSize: res.sp(18), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: res.width,
        height: res.height,
        padding: EdgeInsets.symmetric(horizontal: res.wp(6), vertical: res.hp(3)),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Introduction
              PolicySection(
                res: res,
                title: 'Introduction',
                content:
                    'QuickPitch respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our app.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 2: Information Collection
              PolicySection(
                res: res,
                title: 'Information We Collect',
                content:
                    'We may collect information you provide directly, such as your name, email address, location, and work details. We also collect usage data to improve app functionality and services.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 3: How We Use Information
            PolicySection(
                res: res,
                title: 'How We Use Your Information',
                content:
                    'Your information helps us provide, maintain, and improve the app, communicate with you, process payments, and ensure security. We never sell your personal data to third parties.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 4: Data Security
              PolicySection(
                res: res,
                title: 'Data Security',
                content:
                    'We implement appropriate technical and organizational measures to safeguard your data against unauthorized access, alteration, disclosure, or destruction.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 5: Changes to Privacy Policy
              PolicySection(
                res: res,
                title: 'Changes to this Policy',
                content:
                    'We may update this Privacy Policy from time to time. Changes will be communicated via the app, and continued use signifies acceptance of the updated policy.',
              ),
              SizedBox(height: res.hp(5)),
            ],
          ),
        ),
      ),
    );
  }
}
