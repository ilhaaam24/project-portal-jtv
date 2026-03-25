import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

Widget divider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Container(
      height: 0.5,
      width: double.infinity,
      decoration: BoxDecoration(color: PortalColors.grey500),
    ),
  );
}
