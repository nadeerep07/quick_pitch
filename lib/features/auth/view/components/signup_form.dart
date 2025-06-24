import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_button.dart';
import 'package:quick_pitch_app/features/auth/view/components/form_field.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/button_visibility_state.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/submisson_cubit.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isVisible = !context.watch<ButtonVisibilityCubit>().state.obscureText;
    final authState = context.read<AuthBloc>().state;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            icon: Icons.email_outlined,
            controller: emailController,
            hint: 'Email',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            icon: Icons.lock_outline,
            controller: passwordController,
            hint: 'Password',
            isPassword: true,
            isVisible: isVisible,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            icon: Icons.lock_outline,
            controller: confirmController,
            hint: 'Confirm Password',
            isPassword: true,
            isVisible: isVisible,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: isVisible,
                onChanged: (_) {
                  context
                      .read<ButtonVisibilityCubit>()
                      .togglePasswordVisibility();
                },
              ),
              const Text('Show Passwords'),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Sign Up',
            isLoading: authState is AuthLoading && authState.type == AuthLoadingType.signup,
            onPressed: () => _validateAndSubmit(context),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have account? "),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit(BuildContext context) {
    final submissionCubit = context.read<SubmissionCubit>();
    if (submissionCubit.state) return;

    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        submissionCubit.start();
        context.read<AuthBloc>().add(
          SignUpRequested(
            emailController.text.trim(),
            passwordController.text.trim(),
          ),
        );
      }
    }
  }
}
