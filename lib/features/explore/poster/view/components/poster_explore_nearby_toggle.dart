import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterExploreNearbyToggle extends StatelessWidget {
  final bool enabled;
  final double radius;
  final bool hasLocation;
  final Function(bool) onToggle;
  final Function(double) onRadiusChanged;
  final VoidCallback onLocationRefresh;

  const PosterExploreNearbyToggle({
    super.key,
    required this.enabled,
    required this.radius,
    required this.hasLocation,
    required this.onToggle,
    required this.onRadiusChanged,
    required this.onLocationRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: theme.primaryColor,
                size: res.sp(20),
              ),
              SizedBox(width: res.wp(2)),
              Expanded(
                child: Text(
                  'Search Nearby',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch.adaptive(
                value: enabled && hasLocation,
                onChanged: hasLocation ? onToggle : null,
                activeColor: theme.primaryColor,
              ),
            ],
          ),

          if (!hasLocation) ...[
            SizedBox(height: res.hp(1)),
            Row(
              children: [
                Icon(
                  Icons.location_disabled,
                  color: Colors.orange,
                  size: res.sp(16),
                ),
                SizedBox(width: res.wp(2)),
                Expanded(
                  child: Text(
                    'Location access needed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange[700],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onLocationRefresh,
                  child: Text(
                    'Enable',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: res.sp(12),
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (enabled && hasLocation) ...[
            SizedBox(height: res.hp(2)),
            Text(
              'Search radius: ${radius.toInt()} km',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: res.hp(1)),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: theme.primaryColor,
                thumbColor: theme.primaryColor,
                overlayColor: theme.primaryColor.withOpacity(0.1),
                trackHeight: 4,
              ),
              child: Slider(
                value: radius,
                min: 1,
                max: 50,
                divisions: 49,
                onChanged: onRadiusChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
