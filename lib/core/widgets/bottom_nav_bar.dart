import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/widgets/nav_item.dart';

class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const BottomNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: PortalColors.grey500, width: 0.5),
            ),
          ),
          child: BottomAppBar(
            color: Theme.of(context).colorScheme.surface,
            elevation: 4,
            child: SizedBox(
              height: 60,
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home
                  NavItem(
                    icon: "assets/icons/navigation/home_inactive.png",
                    activeIcon: "assets/icons/navigation/home_active.png",
                    label: 'Beranda',
                    isSelected: currentIndex == 0,
                    onTap: () => _onTabTap(context, 0),
                  ),
                  // Category
                  NavItem(
                    icon: "assets/icons/navigation/category_inactive.png",
                    activeIcon: "assets/icons/navigation/category_active.png",
                    label: 'Kategori',
                    isSelected: currentIndex == 1,
                    onTap: () => _onTabTap(context, 1),
                  ),
                  // Bookmark
                  NavItem(
                    icon: "assets/icons/navigation/play_inactive.png",
                    activeIcon: "assets/icons/navigation/play_active.png",
                    label: 'Live TV',
                    isSelected: currentIndex == 2,
                    onTap: () => _onTabTap(context, 2),
                  ),
                  NavItem(
                    icon: "assets/icons/navigation/archive_inactive.png",
                    activeIcon: "assets/icons/navigation/archive_active.png",
                    label: 'Simpan',
                    isSelected: currentIndex == 3,
                    onTap: () => _onTabTap(context, 3),
                  ),
                  // Profile
                  NavItem(
                    icon: "assets/icons/navigation/user_inactive.png",
                    activeIcon: "assets/icons/navigation/user_active.png",
                    label: 'Profil',
                    isSelected: currentIndex == 4,
                    onTap: () => _onTabTap(context, 4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTabTap(BuildContext context, int index) {
    context.read<NavigationCubit>().changeIndex(index);
    navigationShell.goBranch(index); // ✅ Pakai instance langsung
  }
}
