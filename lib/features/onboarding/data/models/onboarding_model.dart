class OnboardingModel {
  final String image;
  final String background;

  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.background,
    required this.title,
    required this.description,
  });
}

List<OnboardingModel> onboardingList = [
  OnboardingModel(
    title: 'Berita Jawa Timur,\nDalam Genggaman',
    image: 'assets/images/onboarding/onboarding1.png',
    background:
        'assets/images/onboarding/onboarding-bg-1.png', // Ganti dengan path gambar Anda
    description:
        'Update cepat dan terpercaya dari seluruh penjuru Jawa Timur, langsung di layar Anda.',
  ),
  OnboardingModel(
    title: 'Berita Sesuai Minat Anda',
    image: 'assets/images/onboarding/onboarding2.png',
    background: 'assets/images/onboarding/onboarding-bg-2.png',
    description:
        'Jelajahi beragam kanal berita, mulai dari peristiwa hingga gaya hidup.',
  ),
  OnboardingModel(
    title: 'Saksikan JTV\nSecara Langsung',
    image: 'assets/images/onboarding/onboarding3.png',
    background: 'assets/images/onboarding/onboarding-bg-3.png',
    description:
        'Ikuti siaran live JTV kapan saja, tanpa tertinggal momen penting.',
  ),
  OnboardingModel(
    title: 'Berita dalam Format Video',
    image: 'assets/images/onboarding/onboarding4.png',
    background: 'assets/images/onboarding/onboarding-bg-4.png',
    description:
        'Tonton liputan dan highlight berita pilihan dalam sajian visual yang informatif.',
  ),
];
