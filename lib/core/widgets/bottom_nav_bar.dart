import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/widgets/nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home
                NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () {
                    context.read<NavigationCubit>().changeIndex(0);
                    context.go('/');
                  },
                ),
                // Category
                NavItem(
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category,
                  label: 'Kategori',
                  isSelected: currentIndex == 1,
                  onTap: () {
                    context.read<NavigationCubit>().changeIndex(1);
                    context.go('/live');
                  },
                ),
                // Space untuk FAB di tengah
                const SizedBox(width: 48),
                // Bookmark
                NavItem(
                  icon: Icons.bookmark_outline,
                  activeIcon: Icons.bookmark,
                  label: 'Bookmark',
                  isSelected: currentIndex == 2,
                  onTap: () {
                    context.read<NavigationCubit>().changeIndex(2);
                    context.go('/bookmark');
                  },
                ),
                // Profile
                NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  isSelected: currentIndex == 3,
                  onTap: () {
                    context.read<NavigationCubit>().changeIndex(3);
                    context.go('/profile');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
