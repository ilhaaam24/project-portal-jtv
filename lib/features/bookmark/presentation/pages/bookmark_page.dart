import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/bookmark/presentation/widgets/saved_news_card.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_size_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_to_speech_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/pages/detail_page.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_event.dart';
import '../bloc/bookmark_state.dart';
import 'package:portal_jtv/config/injection/injection.dart' as di;

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<BookmarkBloc>()..add(const LoadBookmarks()),
      child: const _BookmarkView(),
    );
  }
}

class _BookmarkView extends StatelessWidget {
  const _BookmarkView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Berita Tersimpan'), centerTitle: true),
      body: BlocConsumer<BookmarkBloc, BookmarkState>(
        // Listener untuk SnackBar
        listener: (context, state) {
          if (state.lastDeleted != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Berita dihapus'),
                  // action: SnackBarAction(
                  //   label: 'UNDO',
                  //   onPressed: () {
                  //     context.read<BookmarkBloc>().add(
                  //       const UndoDeleteBookmark(),
                  //     );
                  //   },
                  // ),
                  duration: const Duration(seconds: 1),
                ),
              );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            // ─── LOADING ───
            case BookmarkStatus.initial:
            case BookmarkStatus.loading:
              return const Center(child: CircularProgressIndicator());

            // ─── ERROR ───
            case BookmarkStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? 'Gagal memuat data'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BookmarkBloc>().add(const LoadBookmarks());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );

            // ─── EMPTY STATE ───
            case BookmarkStatus.empty:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada berita tersimpan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Simpan berita favoritmu agar mudah\ndibaca kembali nanti',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );

            // ─── SUCCESS (ADA DATA) ───
            case BookmarkStatus.success:
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BookmarkBloc>().add(const RefreshBookmarks());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.savedNews.length,
                  itemBuilder: (context, index) {
                    final item = state.savedNews[index];
                    return SavedNewsCard(
                      item: item,
                      onTap: () {
                        _navigateToDetail(context, item);
                      },
                      onDelete: () {
                        context.read<BookmarkBloc>().add(
                          DeleteBookmark(idBerita: item.idBerita, index: index),
                        );
                      },
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, dynamic item) {
    // Buat args dari data bookmark untuk pre-populated detail
    final args = DetailArgsEntity(
      seo: item.berita.seo,
      title: item.berita.title,
      photo: item.berita.photo ?? '',
      date: item.berita.date ?? '',
      category: item.berita.category ?? '',
      author: item.berita.author ?? '',
      picAuthor: item.berita.picAuthor ?? '',
    );

    // Navigate ke detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  di.sl<DetailBloc>()..add(LoadDetail(seo: args.seo)),
            ),
            BlocProvider(create: (_) => di.sl<TextSizeCubit>()),
            BlocProvider(create: (_) => di.sl<TextToSpeechCubit>()),
          ],
          child: DetailPage(args: args),
        ),
      ),
    );
  }
}
