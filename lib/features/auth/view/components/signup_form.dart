import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_button.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Signup successful")));
          Navigator.pop(context); // back to login or home
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
          print('Signup failed: ${state.error}');
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildField(emailController, 'Email'),
            const SizedBox(height: 16),
            _buildField(passwordController, 'Password', isPassword: true),
            const SizedBox(height: 16),
            _buildField(
              confirmController,
              'Confirm Password',
              isPassword: true,
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  text: 'Sign Up',
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (passwordController.text != confirmController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords do not match"),
                          ),
                        );
                      } else {
                        context.read<AuthBloc>().add(
                          SignUpRequested(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (val) {
        if (val == null || val.isEmpty) return '$hint is required';
        if (hint == 'Email' && !val.contains('@')) return 'Enter a valid email';
        if (isPassword && val.length < 6) return 'Minimum 6 characters';
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
