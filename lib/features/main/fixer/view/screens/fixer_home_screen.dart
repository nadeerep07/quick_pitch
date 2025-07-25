import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/build_body.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_shimmer.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart';

class FixerHomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const FixerHomeScreen({super.key, required this.scaffoldKey});

  @override
  State<FixerHomeScreen> createState() => _FixerHomeScreenState();
}

class _FixerHomeScreenState extends State<FixerHomeScreen> {
  @override
  void initState() {
    super.initState();
   final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    context.read<FixerHomeCubit>().loadFixerHomeData(uid);
  }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(5),
                vertical: res.hp(2),
              ),
              child: BlocBuilder<FixerHomeCubit, FixerHomeState>(
                builder: (context, state) {
                  if (state is FixerHomeLoading) {
                    return Center(child: FixerHomeShimmer(res: res));
                  }

                  if (state is FixerHomeError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is FixerHomeLoaded) {
                    return BuildBody(
                      context: context,
                      res: res,
                      state: state,
                      scaffoldKey: widget.scaffoldKey,
                    );
                  }

                  return const Center(child: Text("Loading..."));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
