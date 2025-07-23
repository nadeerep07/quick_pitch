import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/build_header.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/build_section_title.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/build_task_list.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart';

class BuildBody extends StatelessWidget {
  const BuildBody({
    super.key,
    required this.context,
    required this.res,
    required this.state,
    required this.scaffoldKey,
  });

  final BuildContext context;
  final Responsive res;
  final FixerHomeLoaded state;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final newTasks = state.newTasks;
    final profile = state.userProfile;

    return RefreshIndicator(
      onRefresh: () async {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          context.read<FixerHomeCubit>().loadFixerHomeData(uid);
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          BuildHeader(res: res, profile: profile, scaffoldKey: scaffoldKey),
          SizedBox(height: res.hp(3)),
          BuildSectionTitle(
            res: res,
            title: 'Tasks For You',
            filters: [
              'All',
              'Remote',
              'On-site',
              'Morning',
              'Evening',
              'Electrician',
              'Plumber',
              'Today',
              'This Week',
              'High Priority',
            ],
          ),
          SizedBox(height: res.hp(1.5)),
          BuildTaskList(res: res, newTasks: newTasks),
          SizedBox(height: res.hp(2)),
        ],
      ),
    );
  }
}
