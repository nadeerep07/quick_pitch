import 'package:flutter/material.dart';

class CustomDateRangeDisplay extends StatelessWidget {
  final DateTimeRange dateRange;
  final VoidCallback onEditPressed;

  const CustomDateRangeDisplay({
    required this.dateRange,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: const Icon(Icons.date_range),
          title: Text('${_formatDate(dateRange.start)} - ${_formatDate(dateRange.end)}'),
          subtitle: const Text('Custom date range'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEditPressed,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
