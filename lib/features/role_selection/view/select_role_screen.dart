import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/features/role_selection/view/components/backgroun_painter.dart';
import 'package:quick_pitch_app/features/role_selection/view/components/role_card.dart';
import 'package:quick_pitch_app/features/role_selection/viewmodel/cubit/role_selection_viewmodel_cubit.dart';
import 'package:quick_pitch_app/features/role_selection/viewmodel/cubit/role_selection_viewmodel_state.dart';
import 'package:quick_pitch_app/shared/config/responsive.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      body: BlocConsumer<RoleSelectionCubit, RoleSelectionState>(
        listener: (context, state) {
          if (state is RoleSelected) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          final selectedRole = state is RoleTempSelected ? state.role : null;

          return Stack(
            children: [
              CustomPaint(painter: BackgroundPainter(), size: Size.infinite),

              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(6)),
                    child: Column(
                      children: [
                        SizedBox(height: res.hp(5)),
                        Text(
                          "Choose your role",
                          style: TextStyle(
                            fontSize: res.sp(22),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "How would you like to use the app?",
                          style: TextStyle(
                            fontSize: res.sp(15),
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: res.hp(5)),

                        /// Poster card
                        RoleBox(
                          title: "Be a Poster",
                          subtitle: "Post tasks and get them done",
                          imagePath: 'assets/images/poster.jpeg',
                          onTap:
                              () => context
                                  .read<RoleSelectionCubit>()
                                  .selectLocalRole('poster'),
                          isSelected: selectedRole == 'poster',
                          res: res,
                        ),
                        SizedBox(height: res.hp(2)),
                        Text(
                          "or",
                          style: TextStyle(
                            fontSize: res.sp(16),
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: res.hp(2)),

                        /// Fixer  Card
                        RoleBox(
                          title: "Be a Fixer",
                          subtitle: "Earn money by completing tasks",
                          imagePath: 'assets/images/fixer.jpeg',
                          onTap:
                              () => context
                                  .read<RoleSelectionCubit>()
                                  .selectLocalRole('fixer'),
                          isSelected: selectedRole == 'fixer',
                          res: res,
                        ),
                        SizedBox(height: res.hp(4)),

                        AppButton(
                          text: 'Get Started →',
                          onPressed:
                              selectedRole == null
                                  ? null
                                  : () =>
                                      context
                                          .read<RoleSelectionCubit>()
                                          .confirmRoleSelection(),
                          borderRadius: 30,
                        ),
                        SizedBox(height: res.hp(3)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
