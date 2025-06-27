import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/view/screens/login_screen.dart';
import 'package:quick_pitch_app/features/onboarding/viewmodel/bloc/onboarding_bloc.dart';
import 'package:quick_pitch_app/features/onboarding/view/components/onboarding_button.dart';
import 'package:quick_pitch_app/features/onboarding/view/components/onboarding_dot_indicator.dart';
import 'package:quick_pitch_app/features/onboarding/view/components/onboarding_page.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController _pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/onboarding1.jpeg',
      'title': 'Post Your Task in Seconds',
      'subtitle':
          'Describe your need, set a budget, and find a skilled fixer instantly.',
    },
    {
      'image': 'assets/images/onboarding2.jpeg',
      'title': 'Receive Pitches from Experts',
      'subtitle': 'Get multiple offers tailored to your needs — fast and fair.',
    },
    {
      'image': 'assets/images/onboarding3.jpeg',
      'title': 'Connect & Complete with Confidence',
      'subtitle': 'Chat in real-time, mark tasks done, and leave reviews.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Scaffold(
            body: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                context.read<OnboardingBloc>().add(OnPageChanged(index));
              },
              itemBuilder: (context, index) {
                final data = pages[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OnboardingPage(
                      imagePath: data['image']!,
                      title: data['title']!,
                      subtitle: data['subtitle']!,
                    ),
                    SizedBox(height: res.hp(5)),

                    OnboardingDotsIndicator(
                      currentIndex: state.currentIndex,
                      itemCount: pages.length,
                    ),

                    SizedBox(height: res.hp(5)),
                    OnboardingNextButton(
                      isLast: state.currentIndex == pages.length - 1,
                      onPressed: () async {
                        if (state.currentIndex < pages.length - 1) {
                          context.read<OnboardingBloc>().add(NextPageTapped());
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          final prefs = await SharedPreferences.getInstance();
                        
                          await prefs.setBool('onboarding_done', true);
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      LoginScreen(),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
