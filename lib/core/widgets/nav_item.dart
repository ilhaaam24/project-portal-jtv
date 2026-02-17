import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

class NavItem extends StatelessWidget {
  final String icon;
  final String activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorbg = isSelected
        ? Theme.of(context).brightness == Brightness.light
              ? PortalColors.jtvBiru
              : PortalColors.white
        : Colors.transparent;
    final colortext = isSelected
        ? Theme.of(context).brightness == Brightness.light
              ? PortalColors.white
              : PortalColors.jtvBiru
        : PortalColors.grey500;
    return Expanded(
      child: Material(
        color: colorbg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isSelected ? activeIcon : icon,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: colortext,
                    fontSize: 10,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
