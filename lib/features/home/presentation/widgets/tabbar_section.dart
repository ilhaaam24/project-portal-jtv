import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

class TabbarSection extends StatefulWidget {
  const TabbarSection({super.key});

  @override
  State<TabbarSection> createState() => _TabbarSectionState();
}

class _TabbarSectionState extends State<TabbarSection>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelPadding: EdgeInsets.all(10),
      tabs: [
        Text(
          "TERBARU",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: PortalColors.white,
            fontSize: 14,
          ),
        ),
        Text(
          "TERPOPULER",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: PortalColors.white,
            fontSize: 14,
          ),
        ),
        Text(
          "FOR YOU",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: PortalColors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
