import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

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
              _PolicySection(
                res: res,
                title: 'Introduction',
                content:
                    'QuickPitch respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our app.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 2: Information Collection
              _PolicySection(
                res: res,
                title: 'Information We Collect',
                content:
                    'We may collect information you provide directly, such as your name, email address, location, and work details. We also collect usage data to improve app functionality and services.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 3: How We Use Information
              _PolicySection(
                res: res,
                title: 'How We Use Your Information',
                content:
                    'Your information helps us provide, maintain, and improve the app, communicate with you, process payments, and ensure security. We never sell your personal data to third parties.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 4: Data Security
              _PolicySection(
                res: res,
                title: 'Data Security',
                content:
                    'We implement appropriate technical and organizational measures to safeguard your data against unauthorized access, alteration, disclosure, or destruction.',
              ),
              SizedBox(height: res.hp(3)),

              // Section 5: Changes to Privacy Policy
              _PolicySection(
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

// -------------------- POLICY SECTION --------------------
class _PolicySection extends StatelessWidget {
  final Responsive res;
  final String title;
  final String content;

  const _PolicySection({
    required this.res,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(res.wp(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            content,
            style: TextStyle(
              fontSize: res.sp(14),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
