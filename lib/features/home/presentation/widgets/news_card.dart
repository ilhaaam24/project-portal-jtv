import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';

Widget buildNewsCard(NewsEntity news, BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        final args = DetailArgsEntity.fromNewsEntity(news);
        context.pushNamed("detail", extra: args);
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── GAMBAR ───
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                news.photo,
                width: 110,
                height: 100, // ← bebas atur tinggi di sini
                fit: BoxFit.cover, // ← cover lebih baik untuk thumbnail
                errorBuilder: (_, _, _) => Container(
                  width: 110,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ─── TEKS ───
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 3, // ← bisa lebih banyak baris
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${news.author} • ${formatDate(news.date)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
