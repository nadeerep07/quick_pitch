import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/build_body.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart';

class FixerHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey ;
  const FixerHomeScreen({super.key,required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FixerHomeError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is FixerHomeLoaded) {
                    return BuildBody(context: context, res: res, state: state,
                        scaffoldKey: scaffoldKey);
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
