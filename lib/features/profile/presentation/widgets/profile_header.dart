// lib/features/profile/presentation/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/utils/string_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileHeader extends StatelessWidget {
  final String nama;
  final String email;
  final String photo;

  const ProfileHeader({
    super.key,
    required this.nama,
    required this.email,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          // Avatar
          Skeleton.leaf(
            enabled: true,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: PortalColors.jtvBiru,
              backgroundImage: photo.isNotEmpty
                  ? CachedNetworkImageProvider(photo)
                  : null,
              child: Text(
                StringUtils.getInitials(nama),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Skeleton.leaf(
            enabled: true,
            child: SizedBox(
              child: email == "-"
                  ? TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: PortalColors.jtvBiru,
                      ),
                      onPressed: () {
                        context.pushNamed(
                          'sign-in',
                          extra: {'fromGuard': true},
                        );
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Email
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          // Nama
        ],
      ),
    );
  }
}
