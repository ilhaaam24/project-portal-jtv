import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/onboarding/data/models/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late PageController _controller;

  // Animation controllers — staggered entry for each element
  late AnimationController _imageAnimController;
  late AnimationController _titleAnimController;
  late AnimationController _subtitleAnimController;

  // Image animations
  late Animation<double> _imageFade;
  late Animation<Offset> _imageSlide;
  late Animation<double> _imageScale;

  // Title animations
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;

  // Subtitle animations
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);

    // --- Animation Controllers ---
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _subtitleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // --- Setup Animations ---
    // Image: fade + slide up + scale up
    _imageFade = CurvedAnimation(
      parent: _imageAnimController,
      curve: Curves.easeOutCubic,
    );
    _imageSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _imageAnimController,
            curve: Curves.easeOutCubic,
          ),
        );
    _imageScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _imageAnimController, curve: Curves.easeOutCubic),
    );

    // Title: fade + slide from right
    _titleFade = CurvedAnimation(
      parent: _titleAnimController,
      curve: Curves.easeOutCubic,
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _titleAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Subtitle: fade + slide from right
    _subtitleFade = CurvedAnimation(
      parent: _subtitleAnimController,
      curve: Curves.easeOutCubic,
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _subtitleAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Play animations on first page
    _playEntryAnimations();
  }

  Future<void> _playEntryAnimations() async {
    // Reset all
    _imageAnimController.reset();
    _titleAnimController.reset();
    _subtitleAnimController.reset();

    // Staggered entry: image → title → subtitle
    _imageAnimController.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    _titleAnimController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _subtitleAnimController.forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    _playEntryAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    _imageAnimController.dispose();
    _titleAnimController.dispose();
    _subtitleAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PortalColors.jtvBiru,
      body: Stack(
        children: [
          // ── 1. Background Biru Nyambung (Continuous Gradient) ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A1F3D), // Darker blue at top
                    PortalColors.jtvBiru, // Brand blue
                    Color(0xFF0D2748), // Slightly different at bottom
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // Subtle decorative circles for depth
          Positioned(
            top: -screenHeight * 0.1,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          Positioned(
            bottom: -screenHeight * 0.05,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),

          // ── 2. Content ──
          Column(
            children: [
              // PageView with animated content
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: _onPageChanged,
                  itemCount: onboardingList.length,
                  itemBuilder: (context, index) {
                    return _buildSlideContent(context, index);
                  },
                ),
              ),

              // ── 3. Bottom section: Dots & Button (static) ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Dot indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingList.length,
                        (index) => _buildDot(index, context),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              currentIndex == onboardingList.length - 1
                              ? PortalColors.jtvJingga
                              : Colors.white.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: currentIndex == onboardingList.length - 1
                                  ? Colors.transparent
                                  : Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (currentIndex == onboardingList.length - 1) {
                            context.pushReplacementNamed('home');
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          currentIndex == onboardingList.length - 1
                              ? "Mulai"
                              : "Selanjutnya",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the animated content for each slide.
  /// Animations only play on the currently visible page.
  Widget _buildSlideContent(BuildContext context, int index) {
    final bool isActive = index == currentIndex;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Animated Image ──
        isActive
            ? FadeTransition(
                opacity: _imageFade,
                child: SlideTransition(
                  position: _imageSlide,
                  child: ScaleTransition(
                    scale: _imageScale,
                    child: SizedBox(
                      height: 500,
                      child: Image.asset(
                        onboardingList[index].image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            : Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 500,
                  child: Image.asset(
                    onboardingList[index].image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

        const SizedBox(height: 16),

        // ── Animated Title ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: isActive
              ? FadeTransition(
                  opacity: _titleFade,
                  child: SlideTransition(
                    position: _titleSlide,
                    child: Text(
                      onboardingList[index].title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            color: PortalColors.white,
                          ),
                    ),
                  ),
                )
              : Opacity(
                  opacity: 0,
                  child: Text(
                    onboardingList[index].title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: PortalColors.white,
                    ),
                  ),
                ),
        ),

        const SizedBox(height: 8),

        // ── Animated Subtitle ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: isActive
              ? FadeTransition(
                  opacity: _subtitleFade,
                  child: SlideTransition(
                    position: _subtitleSlide,
                    child: Text(
                      onboardingList[index].description,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                )
              : Opacity(
                  opacity: 0,
                  child: Text(
                    onboardingList[index].description,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 8,
      width: currentIndex == index ? 28 : 8,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? PortalColors.jtvJingga
            : Colors.white.withValues(alpha: 0.4),
      ),
    );
  }
}
