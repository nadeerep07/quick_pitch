import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/email_verification_viewmodel.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final VerificationViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = VerificationViewModel();
    viewModel.startCountdown();
    viewModel.startVerificationCheck(() {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: const Text("Email Verification"),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mark_email_read_outlined, size: 64, color: Colors.blue),
                 SizedBox(height: 16),
                const Text(
                  'Check Your Email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'A verification email has been sent to\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<int>(
                  valueListenable: viewModel.seconds,
                  builder: (_, seconds, __) {
                    return Text(
                      seconds == 0
                          ? "Didn't receive the email?"
                          : "You can resend in $seconds seconds",
                      style: TextStyle(
                        color: seconds == 0 ? Colors.redAccent : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: viewModel.canResend,
                  builder: (_, canResend, __) {
                    return ElevatedButton.icon(
                      onPressed: canResend ? () => viewModel.resendEmail(context) : null,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Resend Email"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor:  AppColors.primaryColor ,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  icon: const Icon(Icons.cancel, color: Colors.redAccent),
                  label: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
