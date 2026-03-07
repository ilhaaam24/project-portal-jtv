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

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background dengan AnimatedSwitcher agar transisinya halus (Fade)
          Positioned.fill(
            bottom: -4,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              // Tambahkan layoutBuilder ini agar background tidak 'melompat'
              layoutBuilder:
                  (Widget? currentChild, List<Widget> previousChildren) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[...previousChildren, ?currentChild],
                    );
                  },
              child: Image.asset(
                onboardingList[currentIndex].background,
                key: ValueKey<int>(currentIndex),
                fit: BoxFit.cover,
                // Pastikan ukuran image mengisi seluruh layar
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 32),

              // 2. PAGEVIEW: Gambar dan Teks dimasukkan ke sini agar bergeser mengikuti jari
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gambar Mockup HP
                        SizedBox(
                          height:
                              600, // Saya kurangi sedikit agar teks tidak terpotong (overflow)
                          child: Image.asset(
                            onboardingList[index]
                                .image, // Diperbaiki: Menggunakan 'index', bukan 'currentIndex'
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Teks Judul & Deskripsi
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
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

              // 3. BAGIAN STATIS: Dots & Tombol tetap di bawah dan tidak ikut tergeser
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
                      height:
                          50, // Opsional: memberi tinggi standar untuk tombol
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
      // Diubah menjadi AnimatedContainer agar perubahannya halus
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
