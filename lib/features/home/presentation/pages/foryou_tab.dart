// lib/features/home/presentation/widgets/for_you_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:portal_jtv/features/home/domain/entities/for_you_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_state.dart';
import 'package:portal_jtv/features/home/presentation/widgets/news_card.dart';

class ForYouTab extends StatefulWidget {
  const ForYouTab({super.key});

  @override
  State<ForYouTab> createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ForYouBloc, ForYouState>(
      builder: (context, state) {
        if (state.status == ForYouStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(state.errorMessage ?? 'Gagal memuat'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<ForYouBloc>().add(const LoadForYou()),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final isLoading =
            state.status == ForYouStatus.loading ||
            state.status == ForYouStatus.initial;

        if (!isLoading && state.status == ForYouStatus.empty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.recommend, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada rekomendasi',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login dan pilih minat Anda untuk mendapatkan rekomendasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        final newsList = isLoading ? _dummyForYouNews : state.news;

        return Skeletonizer(
          enabled: isLoading,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ForYouBloc>().add(const RefreshForYou());
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final item = newsList[index];
                // Map ForYouEntity to NewsEntity to use shared NewsCard
                final news = NewsEntity(
                  idBerita: item.id,
                  title: item.title,
                  seo: item.seo,
                  photo: item.photo,
                  date: item.date,
                  category: item.categoryName,
                  author:
                      'Portal JTV', // Default author as it's missing in ForYouEntity
                  picAuthor: '',
                  seoAuthor: '',
                  seoCategory: '',
                  seoBiro: '',
                  status: 'published',
                  summary: '',
                  caption: '',
                  city: '',
                  isYoutube: false,
                );
                return NewsCard(news: news);
              },
            ),
          ),
        );
      },
    );
  }
}

const _dummyForYou = ForYouEntity(
  id: 0,
  title: 'Judul berita rekomendasi untuk Anda yang sedang dimuat oleh sistem',
  seo: '',
  photo: '',
  date: '2024-01-01',
  categoryName: 'Rekomendasi',
  score: 0,
);

final _dummyForYouNews = List.generate(5, (index) => _dummyForYou);
