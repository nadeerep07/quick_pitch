import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_completion_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_item.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_progress_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_rejection_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_repitch_button.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_task_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchDetailUIHelper {
  final BuildContext context;
  final Responsive res;
  final FixerPitchDetailState state;
  final PitchModel initialPitch;

  FixerPitchDetailUIHelper({
    required this.context,
    required this.res,
    required this.state,
    required this.initialPitch,
  });

  ThemeData get theme => Theme.of(context);
  ColorScheme get colorScheme => theme.colorScheme;
  PitchModel get currentPitch => _extractPitch(state);
  TaskPostModel? get currentTask => _extractTask(state);

  AppBar buildAppBar() {
    final isAssigned = currentPitch.status.toLowerCase() == 'accepted';
    final isCompleted = currentPitch.status.toLowerCase() == 'completed';

    return AppBar(
      title: Text('Pitch Details', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (isAssigned || isCompleted)
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            onPressed: () => _showStatusOptions(isCompleted),
          ),
      ],
    );
  }

  Widget buildDetailBody() {
    final isRejected = currentPitch.status.toLowerCase() == 'rejected';
    final isAssigned = currentPitch.status.toLowerCase() == 'accepted';
    final isCompleted = currentPitch.status.toLowerCase() == 'completed';

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(12), res.wp(5), res.hp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              SizedBox(height: res.hp(3)),
              if (isRejected) FixerPitchDetailRejectionCard(res: res, theme: theme, colorScheme: colorScheme, currentPitch: currentPitch),
              if (isRejected) SizedBox(height: res.hp(3)),
              if (currentTask != null) ...[
                FixerPitchDetailTaskCard(res: res, task: currentTask!, theme: theme, colorScheme: colorScheme),
                SizedBox(height: res.hp(3)),
              ],
              if (isAssigned) ...[
                FixerPitchDetailProgressSection(res: res, context: context, theme: theme, colorScheme: colorScheme, currentPitch: currentPitch),
                SizedBox(height: res.hp(3)),
              ],
              if (isCompleted) ...[
                FixerPitchDetailCompletionSection(res: res, theme: theme, colorScheme: colorScheme, currentPitch: currentPitch),
                SizedBox(height: res.hp(3)),
              ],
              _buildDetailsCard(),
              SizedBox(height: res.hp(3)),
              if (isRejected) FixerPitchDetailRepitchButton(context: context, theme: theme, colorScheme: colorScheme, currentPitch: currentPitch),
              if (isAssigned) _buildAssignedActions(),
              if (isCompleted) _buildCompletedActions(),
            ],
          ),
        ),
        if (state is FixerPitchDetailProcessing)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 12),
                    Text((state as FixerPitchDetailProcessing).message, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryContainer)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  PitchModel _extractPitch(FixerPitchDetailState state) {
    if (state is FixerPitchDetailLoaded) return state.pitch;
    if (state is FixerPitchDetailProcessing) return state.pitch;
    return initialPitch;
  }

  TaskPostModel? _extractTask(FixerPitchDetailState state) {
    if (state is FixerPitchDetailLoaded) return state.task;
    if (state is FixerPitchDetailProcessing) return state.task;
    return null;
  }

  void _showStatusOptions(bool isCompleted) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(res.wp(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isCompleted)
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Mark as Completed'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showCompletionDialog();
                },
              ),
            if (isCompleted)
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Request Payment'),
                onTap: () {
                  Navigator.pop(ctx);
                  _requestPayment();
                },
              ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Message'),
              onTap: () => Navigator.pop(ctx),
            ),
            SizedBox(height: res.hp(2)),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(res.wp(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mark Task as Completed', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: res.hp(2)),
              Text('Add any completion notes for the poster:', style: theme.textTheme.bodyMedium),
              SizedBox(height: res.hp(2)),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter completion notes...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
                maxLines: 4,
              ),
              SizedBox(height: res.hp(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  SizedBox(width: res.wp(3)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FixerPitchDetailCubit>().markAsCompleted(currentPitch.id, controller.text);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Complete'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _requestPayment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Payment'),
        content: Text('Request payment of \$${currentPitch.budget.toStringAsFixed(2)} from the poster?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Request')),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<FixerPitchDetailCubit>().requestPayment(currentPitch.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment request sent successfully')));
    }
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Row(
          children: [
            Container(
              width: res.sp(50),
              height: res.sp(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 2),
              ),
              child: ClipOval(
                child: currentPitch.posterImage != null
                    ? Image.network(currentPitch.posterImage!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.person, size: res.sp(24), color: colorScheme.primary))
                    : Icon(Icons.person, size: res.sp(24), color: colorScheme.primary),
              ),
            ),
            SizedBox(width: res.wp(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentPitch.posterName ?? 'Unknown Poster', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: res.hp(0.5)),
                  Text('Submitted ${_formatDate(currentPitch.createdAt)}', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: res.wp(3), vertical: res.hp(0.8)),
              decoration: BoxDecoration(
                color: _getStatusColor(currentPitch.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getStatusColor(currentPitch.status), width: 1),
              ),
              child: Text(
                currentPitch.status.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(currentPitch.status),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PITCH DETAILS', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.6), letterSpacing: 1)),
            SizedBox(height: res.hp(2)),
            FixerPitchDetailItem(res: res, icon: Icons.message_outlined, label: 'Message', value: currentPitch.pitchText, theme: theme, colorScheme: colorScheme),
            SizedBox(height: res.hp(2)),
            FixerPitchDetailItem(res: res, icon: Icons.attach_money, label: 'Budget', value: '\$${currentPitch.budget.toStringAsFixed(2)}', theme: theme, colorScheme: colorScheme),
            SizedBox(height: res.hp(2)),
            FixerPitchDetailItem(res: res, icon: Icons.schedule, label: 'Timeline', value: currentPitch.timeline, theme: theme, colorScheme: colorScheme),
            if (currentPitch.hours != null && currentPitch.hours!.isNotEmpty)
              ...[
                SizedBox(height: res.hp(2)),
                FixerPitchDetailItem(res: res, icon: Icons.access_time, label: 'Estimated Hours', value: currentPitch.hours!, theme: theme, colorScheme: colorScheme),
              ],
            SizedBox(height: res.hp(2)),
            FixerPitchDetailItem(res: res, icon: Icons.payment, label: 'Payment Type', value: currentPitch.paymentType.toString().split('.').last, theme: theme, colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'Mark as Completed',
            onPressed: _showCompletionDialog,
          ),
        ),
        SizedBox(height: res.hp(2)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showUpdateDialog( context, currentPitch),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: res.hp(2)),
              side: BorderSide(color: colorScheme.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Add Work Update', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
Future<void> _showUpdateDialog(BuildContext context, PitchModel currentPitch) async {
    final updateController = TextEditingController();
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(res.wp(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Work Update',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: res.hp(2)),
              Text(
                'Share your progress with the poster:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: res.hp(2)),
              TextField(
                controller: updateController,
                decoration: InputDecoration(
                  hintText: 'Enter your update...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                maxLines: 4,
                minLines: 3,
              ),
              SizedBox(height: res.hp(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: res.wp(3)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FixerPitchDetailCubit>().addWorkUpdate(
                        currentPitch.id,
                        updateController.text,
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCompletedActions() {
    final isRequested = currentPitch.paymentStatus?.toLowerCase() == 'requested';
    final isDone = currentPitch.paymentStatus?.toLowerCase() == 'completed';

    if (isRequested) {
      return _buildPaymentStatus('Payment Requested', Colors.orange);
    } else if (isDone) {
      return _buildPaymentStatus('Payment Completed', Colors.green);
    }

    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: 'Request Payment',
        onPressed: _requestPayment,
      ),
    );
  }

  Widget _buildPaymentStatus(String label, Color color) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: res.hp(2)),
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: theme.textTheme.bodyLarge?.copyWith(color: color, fontWeight: FontWeight.w600)),
      ),
    );
  }
   String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}