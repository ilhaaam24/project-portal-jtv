// lib/features/profile/presentation/pages/faq_page.dart

import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  static const _faqItems = [
    {
      'q': 'Bagaimana cara menyimpan berita?',
      'a':
          'Buka berita yang ingin disimpan, lalu tap ikon bookmark (🔖) di bagian atas halaman.',
    },
    {
      'q': 'Apakah berita yang disimpan bisa diakses offline?',
      'a':
          'Saat ini berita tersimpan memerlukan koneksi internet untuk dibaca.',
    },
    {
      'q': 'Bagaimana cara mengganti password?',
      'a':
          'Buka Profile → Edit Biodata → isi field Password Baru → tap Simpan.',
    },
    {
      'q': 'Bagaimana cara menghubungi redaksi?',
      'a':
          'Anda dapat menghubungi kami melalui email redaksi@portaljtv.com atau telepon (031) 123-4567.',
    },
    {
      'q': 'Apakah aplikasi ini gratis?',
      'a': 'Ya, aplikasi ini sepenuhnya gratis untuk digunakan.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                item['q']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    item['a']!,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
