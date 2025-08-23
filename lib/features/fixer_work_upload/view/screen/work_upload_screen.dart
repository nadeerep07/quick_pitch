import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/add_work_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/fixer_work_error.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/loading_state.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/section_header.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/works_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_event.dart';

class FixerWorksSection extends StatefulWidget {
  final String fixerId;
  final ThemeData theme;
  final bool isOwner;

  const FixerWorksSection({
    super.key,
    required this.fixerId,
    required this.theme,
    this.isOwner = false,
  });

  @override
  State<FixerWorksSection> createState() => _FixerWorksSectionState();
}

class _FixerWorksSectionState extends State<FixerWorksSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    context.read<FixerWorksBloc>().add(LoadFixerWorks(widget.fixerId));

    return BlocBuilder<FixerWorksBloc, FixerWorksState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: widget.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.theme.colorScheme.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                theme: widget.theme,
                isOwner: widget.isOwner,
                onAddPressed: () => _showAddWorkDialog(context),
              ),
              if (state is FixerWorksLoading)
                LoadingState(theme: widget.theme)
              else if (state is FixerWorksError)
                FixerWorkError(widget: widget, context: context, message: state.message)
              else if (state is FixerWorksLoaded)
              WorksContent(
                  theme: widget.theme,
                  works: state.works,
                  showAll: _showAll,
                  isOwner: widget.isOwner,
                  onToggleView: () => setState(() => _showAll = !_showAll),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  void _showAddWorkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<FixerWorksBloc>(context),
        child: AddWorkDialog(fixerId: widget.fixerId, theme: widget.theme),
      ),
    );
  }
}
