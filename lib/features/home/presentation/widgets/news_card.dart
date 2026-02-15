import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';

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
        context.pushNamed("detail", extra: args);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => MultiBlocProvider(
        //       providers: [
        //         BlocProvider(
        //           create: (_) =>
        //               sl<DetailBloc>()..add(LoadDetail(seo: args.seo)),
        //         ),
        //         BlocProvider(create: (_) => sl<TextSizeCubit>()),
        //         BlocProvider(create: (_) => sl<TextToSpeechCubit>()),
        //       ],
        //       child: DetailPage(args: args),
        //     ),
        //   ),
        // );
      },
    ),
  );
}
