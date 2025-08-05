import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/utils/time_utils.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/screen/fixer_side_detail_screen.dart';

class FixerTaskCard extends StatelessWidget {
  final dynamic task;
  final Responsive res;

  const FixerTaskCard({super.key, required this.task, required this.res});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_) => FixerSideDetailScreen(task: task),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: res.hp(2)),
        padding: EdgeInsets.all(res.wp(4)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: res.hp(1.5)),
            _buildDescription(),
            SizedBox(height: res.hp(1.5)),
            if (task.skills != null && task.skills!.isNotEmpty) _buildSkills(),
            _buildLocation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTaskImage(),
        SizedBox(width: res.wp(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posted ${TimeUtils.getTimeAgo(task.createdAt)}',
                style: TextStyle(
                  fontSize: res.sp(11),
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: res.hp(0.5)),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: res.hp(0.5)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '₹${task.budget}',
                  style: TextStyle(
                    fontSize: res.sp(12),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: res.wp(20),
        height: res.wp(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: task.imagesUrl != null && task.imagesUrl!.isNotEmpty
            ? Image.network(
                task.imagesUrl!.first,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image,
                  color: Color(0xFF94A3B8),
                  size: 32,
                ),
              )
            : const Icon(
                Icons.work_outline,
                color: Color(0xFF94A3B8),
                size: 32,
              ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      task.description,
      style: TextStyle(
        fontSize: res.sp(13),
        color: const Color(0xFF475569),
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSkills() {
    return Column(
      children: [
        Wrap(
          spacing: res.wp(2),
          runSpacing: res.hp(0.5),
          children: task.skills!.take(3).map<Widget>((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  fontSize: res.sp(10),
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: res.hp(1)),
      ],
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
        SizedBox(width: res.wp(1)),
        Expanded(
          child: Text(
            task.location,
            style: TextStyle(
              fontSize: res.sp(12),
              color: const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'View Details',
            style: TextStyle(
              fontSize: res.sp(11),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
