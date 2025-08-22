import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/components/add_work_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/components/work_detail_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_event.dart';

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
              _buildHeader(),
              if (state is FixerWorksLoading)
                _buildLoadingState()
              else if (state is FixerWorksError)
                _buildErrorWidget(state.message)
              else if (state is FixerWorksLoaded)
                _buildWorksContent(context, state.works)
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.theme.primaryColor.withOpacity(0.1),
            widget.theme.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.work_outline,
                  color: widget.theme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Portfolio',
                style: widget.theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          if (widget.isOwner) _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.theme.primaryColor,
            widget.theme.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.theme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showAddWorkDialog(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Add Work',
                  style: widget.theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: widget.theme.primaryColor,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading portfolio...',
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorksContent(BuildContext context, List<FixerWork> works) {
    if (works.isEmpty) {
      return _buildEmptyState();
    }

    final displayWorks = _showAll ? works : works.take(3).toList();
    final hasMore = works.length > 3;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${works.length} ${works.length == 1 ? 'Project' : 'Projects'}',
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildWorksGrid(context, displayWorks),
          if (hasMore && !_showAll) ...[
            const SizedBox(height: 20),
            _buildViewMoreButton(works.length - 3),
          ],
          if (_showAll && hasMore) ...[
            const SizedBox(height: 20),
            _buildShowLessButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildWorksGrid(BuildContext context, List<FixerWork> works) {
    if (_showAll) {
      // Full grid view when showing all
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: works.length,
        itemBuilder: (context, index) {
          return _buildWorkCard(context, works[index]);
        },
      );
    } else {
      // Limited view - show only 3 works
      return Column(
        children:
            works.asMap().entries.map((entry) {
              final index = entry.key;
              final work = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < works.length - 1 ? 16 : 0,
                ),
                child: _buildCompactWorkCard(context, work),
              );
            }).toList(),
      );
    }
  }

  Widget _buildWorkCard(BuildContext context, FixerWork work) {
    return Container(
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showWorkDetail(context, work),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildImageSection(work)),
              Expanded(flex: 2, child: _buildCardContent(work)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactWorkCard(BuildContext context, FixerWork work) {
    return Container(
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showWorkDetail(context, work),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildCompactImage(work),
                const SizedBox(width: 16),
                Expanded(child: _buildCompactContent(work)),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: widget.theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(FixerWork work) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          work.images.isNotEmpty
              ? CachedNetworkImage(
                imageUrl: work.images.first,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: widget.theme.colorScheme.surfaceVariant,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: widget.theme.primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: widget.theme.colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 32,
                        color: widget.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
              )
              : Container(
                color: widget.theme.colorScheme.surfaceVariant,
                child: Center(
                  child: Icon(
                    Icons.work_outline,
                    size: 32,
                    color: widget.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          if (work.images.length > 1)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_library, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${work.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactImage(FixerWork work) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.theme.colorScheme.surfaceVariant,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            work.images.isNotEmpty
                ? CachedNetworkImage(
                  imageUrl: work.images.first,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: widget.theme.colorScheme.surfaceVariant,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: widget.theme.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Icon(
                        Icons.image_not_supported_outlined,
                        size: 20,
                        color: widget.theme.colorScheme.onSurfaceVariant,
                      ),
                )
                : Icon(
                  Icons.work_outline,
                  size: 24,
                  color: widget.theme.colorScheme.onSurfaceVariant,
                ),
      ),
    );
  }

  Widget _buildCardContent(FixerWork work) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            work.title,
            style: widget.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: widget.theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            work.description,
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${work.amount.toStringAsFixed(0)}',
                  style: widget.theme.textTheme.labelMedium?.copyWith(
                    color: widget.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                work.time,
                style: widget.theme.textTheme.labelSmall?.copyWith(
                  color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactContent(FixerWork work) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          work.title,
          style: widget.theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          work.description,
          style: widget.theme.textTheme.bodySmall?.copyWith(
            color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: widget.theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '₹${work.amount.toStringAsFixed(0)}',
                style: widget.theme.textTheme.labelSmall?.copyWith(
                  color: widget.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.schedule_outlined,
              size: 12,
              color: widget.theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 4),
            Text(
              work.time,
              style: widget.theme.textTheme.labelSmall?.copyWith(
                color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewMoreButton(int remainingCount) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.theme.primaryColor.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _showAll = true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View $remainingCount More Projects',
                    style: widget.theme.textTheme.labelMedium?.copyWith(
                      color: widget.theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.expand_more_rounded,
                    size: 20,
                    color: widget.theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowLessButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _showAll = false),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Show Less',
                    style: widget.theme.textTheme.labelMedium?.copyWith(
                      color: widget.theme.colorScheme.onSurface.withOpacity(
                        0.7,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.expand_less_rounded,
                    size: 20,
                    color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surfaceVariant.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_outline,
              size: 40,
              color: widget.theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.isOwner ? 'No projects yet' : 'No projects to display',
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isOwner
                ? 'Start building your portfolio by adding your first project'
                : 'This fixer hasn\'t added any projects yet',
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.isOwner) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddWorkDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Your First Project'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, size: 32, color: Colors.red[400]),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load projects',
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              context.read<FixerWorksBloc>().add(
                LoadFixerWorks(widget.fixerId),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showAddWorkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: BlocProvider.of<FixerWorksBloc>(context),
            child: AddWorkDialog(fixerId: widget.fixerId, theme: widget.theme),
          ),
    );
  }

  void _showWorkDetail(BuildContext context, FixerWork work) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: BlocProvider.of<FixerWorksBloc>(context),
            child: WorkDetailDialog(
              work: work,
              theme: widget.theme,
              isOwner: widget.isOwner,
            ),
          ),
    );
  }
}
