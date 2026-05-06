import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/auth/presentation/widgets/tab_signin.dart';

class AuthPage extends StatelessWidget {
  final bool fromGuard;

  const AuthPage({super.key, this.fromGuard = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PortalColors.jtvBiru,
      appBar: AppBar(
        title: Image.asset('assets/logos/logo-jtv-white.png', height: 24),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: PortalColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        'Masuk',
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(
                              color: PortalColors.jtvJingga,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    const Divider(color: PortalColors.jtvJingga, thickness: 2),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TabSignin(fromGuard: fromGuard),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
