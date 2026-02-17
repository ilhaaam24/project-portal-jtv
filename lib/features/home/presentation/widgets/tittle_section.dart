import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

class TittleSection extends StatelessWidget {
  final String title;
  const TittleSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 24, color: PortalColors.jtvJingga),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
      ],
    );
  }
}
