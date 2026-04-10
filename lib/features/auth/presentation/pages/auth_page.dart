import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/auth/presentation/widgets/tab_signin.dart';

class AuthPage extends StatefulWidget {
  final bool fromGuard;

  const AuthPage({super.key, this.fromGuard = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PortalColors.jtvBiru,
      appBar: AppBar(
        title: Image.asset('assets/logos/logo-jtv-white.png', height: 24),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: PortalColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                dividerHeight: 4,
                labelColor: PortalColors.jtvJingga,
                labelStyle: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),

                indicatorSize: TabBarIndicatorSize.tab,
                automaticIndicatorColorAdjustment: true,
                indicatorColor: PortalColors.jtvJingga,
                dividerColor: Colors.transparent,

                tabs: [
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Masuk',
                      // style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      //   fontWeight: FontWeight.w600,
                      // ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Daftar',
                      // style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      //   fontWeight: FontWeight.w600,
                      // ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [TabSignin(fromGuard: widget.fromGuard)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
