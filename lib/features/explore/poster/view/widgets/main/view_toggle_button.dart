import 'package:flutter/material.dart';

class ViewToggleButton extends StatelessWidget {
  final bool isMapView;
  final VoidCallback onToggle;

  const ViewToggleButton({
    super.key,
    required this.isMapView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // List Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: isMapView ? onToggle : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: !isMapView 
                      ? Colors.white 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: !isMapView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.view_list_rounded,
                        key: ValueKey(!isMapView),
                        color: !isMapView 
                            ? const Color(0xFF6366F1) 
                            : Colors.grey[500],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: !isMapView 
                            ? const Color(0xFF1F2937) 
                            : Colors.grey[500],
                        fontWeight: !isMapView 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                      child: const Text('List'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Map Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: !isMapView ? onToggle : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isMapView 
                      ? Colors.white 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isMapView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.map_rounded,
                        key: ValueKey(isMapView),
                        color: isMapView 
                            ? const Color(0xFF10B981) 
                            : Colors.grey[500],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isMapView 
                            ? const Color(0xFF1F2937) 
                            : Colors.grey[500],
                        fontWeight: isMapView 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                      child: const Text('Map'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}