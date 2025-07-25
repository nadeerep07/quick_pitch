import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class GlassmorphicBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final VoidCallback onPostTapped;
  final bool isFixer;

  const GlassmorphicBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onPostTapped,
    required this.isFixer,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return SafeArea(
      top: false,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: res.hp(9.5),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      isFixer
                          ? [
                            _navItem(context, Icons.home, "Home", 0),
                            _navItem(context, Icons.search, "Explore", 1),
                            _navItem(context, Icons.chat, " chats  ", 2),
                            _navItem(
                              context,
                              Icons.receipt_long,
                              "Requests",
                              3,
                            ),
                            _navItem(context, Icons.attach_money, "Earning", 4),
                          ]
                          : [
                            _navItem(context, Icons.home, "Home", 0),
                            _navItem(context, Icons.search, "Explore", 1),
                            const Spacer(),
                            _navItem(context, Icons.chat, " chats  ", 2),
                            _navItem(
                              context,
                              Icons.receipt_long,
                              "Requests",
                              3,
                            ),
                          ],
                ),
              ),
            ),
          ),

          // Center Post Button
          if (!isFixer)
            Positioned(
              bottom: res.hp(4.5),
              child: GestureDetector(
                onTap: onPostTapped,
                child: Container(
                  height: res.wp(16),
                  width: res.wp(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryColor.withValues(alpha: .15)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.primaryColor : Colors.black38,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primaryColor : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
