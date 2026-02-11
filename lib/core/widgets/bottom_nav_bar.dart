import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/widgets/nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

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
            elevation: 8,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home
                  NavItem(
                    icon: "assets/icons/navigation/home_inactive.png",
                    activeIcon: "assets/icons/navigation/home_active.png",
                    label: 'Beranda',
                    isSelected: currentIndex == 0,
                    onTap: () {
                      context.read<NavigationCubit>().changeIndex(0);
                      context.go('/');
                    },
                  ),
                  // Category
                  NavItem(
                    icon: "assets/icons/navigation/category_inactive.png",
                    activeIcon: "assets/icons/navigation/category_active.png",
                    label: 'Kategori',
                    isSelected: currentIndex == 1,
                    onTap: () {
                      context.read<NavigationCubit>().changeIndex(1);
                      context.go('/live');
                    },
                  ),
                  // Space untuk FAB di tengah
                  // const SizedBox(width: 48),
                  // Bookmark
                  NavItem(
                    icon: "assets/icons/navigation/play_inactive.png",
                    activeIcon: "assets/icons/navigation/play_active.png",
                    label: 'Live TV',
                    isSelected: currentIndex == 2,
                    onTap: () {
                      context.read<NavigationCubit>().changeIndex(2);
                      context.go('/live');
                    },
                  ),
                  NavItem(
                    icon: "assets/icons/navigation/archive_inactive.png",
                    activeIcon: "assets/icons/navigation/archive_active.png",
                    label: 'Simpan',
                    isSelected: currentIndex == 3,
                    onTap: () {
                      context.read<NavigationCubit>().changeIndex(3);
                      context.go('/bookmark');
                    },
                  ),
                  // Profile
                  NavItem(
                    icon: "assets/icons/navigation/user_inactive.png",
                    activeIcon: "assets/icons/navigation/user_active.png",
                    label: 'Profil',
                    isSelected: currentIndex == 4,
                    onTap: () {
                      context.read<NavigationCubit>().changeIndex(4);
                      context.go('/profile');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
