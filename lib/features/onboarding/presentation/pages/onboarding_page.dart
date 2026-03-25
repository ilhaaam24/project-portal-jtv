import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/onboarding/data/models/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  late PageController _controller;
  late PageController _bgController;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    _bgController = PageController(initialPage: 0);

    // Sync background scroll dengan content scroll secara real-time
    _controller.addListener(_syncBackground);
    super.initState();
  }

  void _syncBackground() {
    if (_controller.position.haveDimensions &&
        _bgController.position.haveDimensions) {
      _bgController.position.jumpTo(_controller.position.pixels);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncBackground);
    _controller.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PortalColors.white,
      body: Stack(
        children: [
          // 1. Background yang ikut scroll bersama PageView (smooth & nyambung)
          Positioned.fill(
            bottom: 0,
            left: 0,
            right: 0,
            child: PageView.builder(
              controller: _bgController,
              // Mencegah user scroll background secara terpisah
              physics: const NeverScrollableScrollPhysics(),
              itemCount: onboardingList.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  onboardingList[index].background,
                  fit: BoxFit.cover,
                  width: screenWidth,
                  height: screenHeight,
                );
              },
            ),
          ),

          Column(
            children: [
              // 2. PAGEVIEW: Gambar dan Teks — menggerakkan background secara sinkron
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemCount: onboardingList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        // Gambar Mockup HP — Expanded agar mengisi sisa ruang
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Image.asset(
                              onboardingList[index].image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // Teks Judul & Deskripsi — selalu tampil di bawah gambar
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                onboardingList[index].title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: PortalColors.white,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                onboardingList[index].description,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: PortalColors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 3. BAGIAN STATIS: Dots & Tombol tetap di bawah
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Indikator Titik
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingList.length,
                        (index) => buildDot(index, context),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tombol
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
                              : PortalColors.grey400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          if (currentIndex == onboardingList.length - 1) {
                            context.pushReplacementNamed('home');
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
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

  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 8,
      width: currentIndex == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? PortalColors.jtvJingga
            : PortalColors.white,
      ),
    );
  }
}
