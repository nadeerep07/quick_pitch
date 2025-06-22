import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/button_visibility_state.dart';
import 'package:quick_pitch_app/shared/config/responsive.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onSignupTap;
  final VoidCallback onLoginTap;
  final VoidCallback onForgotTap;

  const LoginForm({
    super.key,
    required this.onGoogleTap,
    required this.onSignupTap,
    required this.onLoginTap,
    required this.onForgotTap,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primaryText,
            ),
            fillColor: Colors.grey.shade100,
            hintText: 'Enter your email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryText),
            ),
          ),
        ),
        SizedBox(height: res.hp(4)),
        BlocBuilder<ButtonVisibilityCubit, ButtonVisibilityState>(
          builder: (context, state) {
            return TextFormField(
              obscureText: state.obscureText,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.primaryText,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primaryText,
                  ),
                  onPressed: () {
                    context
                        .read<ButtonVisibilityCubit>()
                        .togglePasswordVisibility();
                  },
                ),
                fillColor: Colors.grey.shade100,
                hintText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryText),
                ),
              ),
            );
          },
        ),
        SizedBox(height: res.hp(2)),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: onForgotTap,
            child: Text(
              "Forgot password?",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: res.hp(2)),
        ElevatedButton(onPressed: onLoginTap, child: const Text('Login')),

        SizedBox(height: res.hp(2)),
        ElevatedButton.icon(
          onPressed: onGoogleTap,
          icon: Image.asset('assets/icons/google.png', height: res.hp(3)),
          label: Text(
            'Continue with Google',
            style: TextStyle(fontSize: res.wp(4), color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 2,
            minimumSize: Size(double.infinity, res.hp(6)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        SizedBox(height: res.hp(3)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account? "),
            InkWell(
              onTap: onSignupTap,
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
