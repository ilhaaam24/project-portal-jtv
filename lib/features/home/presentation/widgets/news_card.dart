import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/config/injection/injection.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_size_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_to_speech_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/pages/detail_page.dart';

Widget buildNewsCard(dynamic news, BuildContext context) {
  return Card(
    elevation: 0,
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          news.photo,
          width: 80,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              Container(width: 80, height: 60, color: Colors.grey),
        ),
      ),
      title: Text(news.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text('${news.category} • ${news.date}'),
      onTap: () {
        final args = DetailArgsEntity.fromNewsEntity(news);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      sl<DetailBloc>()..add(LoadDetail(seo: args.seo)),
                ),
                BlocProvider(create: (_) => sl<TextSizeCubit>()),
                BlocProvider(create: (_) => sl<TextToSpeechCubit>()),
              ],
              child: DetailPage(args: args),
            ),
          ),
        );
      },
    ),
  );
}
