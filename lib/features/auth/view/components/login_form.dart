import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/errors/auth_error_mapper.dart'
    show mapFirebaseError;
import 'package:quick_pitch_app/features/auth/view/components/custom_button.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/auth/view/components/form_field.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/button_visibility_state.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onSignupTap;
  final VoidCallback onForgotTap;

  LoginForm({
    super.key,
    required this.onGoogleTap,
    required this.onSignupTap,
    required this.onForgotTap,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
        } else if (state is AuthFailure) {
         // print(state.error.toString());
          showDialog(
            context: context,
            builder:
                (context) => CustomDialog(
                  title: "Signup Failed",
                  message: mapFirebaseError(state.error),
                  icon: Icons.error_outline,
                  iconColor: Colors.red,
                  onConfirm: () => Navigator.of(context).pop(),
                ),
          );
        }
      },
      child: BlocBuilder<ButtonVisibilityCubit, ButtonVisibilityState>(
        builder: (context, visibilityState) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: emailController,
                  hint: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isVisible: !visibilityState.obscureText,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: !visibilityState.obscureText,
                      onChanged: (_) {
                        context
                            .read<ButtonVisibilityCubit>()
                            .togglePasswordVisibility();
                      },
                    ),
                    const Text('Show Password'),
                    const Spacer(),
                    GestureDetector(
                      onTap: widget.onForgotTap,
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    final isEmailLoginLoading =
                        authState is AuthLoading &&
                        authState.type == AuthLoadingType.emailPassword;
                    return CustomButton(
                      text: 'Login',
                      isLoading: isEmailLoginLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            SignInRequested(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: widget.onGoogleTap,
                  icon: Image.asset('assets/icons/google.png', height: 24),
                  label: const Text(
                    "Continue with Google",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 2,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    InkWell(
                      onTap: widget.onSignupTap,
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
