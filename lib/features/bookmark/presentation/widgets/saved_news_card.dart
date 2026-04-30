import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/bookmark/domain/entities/saved_news_entity.dart';
import 'package:share_plus/share_plus.dart';

class SavedNewsCard extends StatelessWidget {
  final SavedNewsEntity item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SavedNewsCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.idSaved),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                  "Apakah kamu yakin ingin menghapus berita ini dari daftar simpan?",
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("BATAL"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onDelete();
                    },
                    child: Text(
                      "HAPUS",
                      style: TextStyle(color: PortalColors.error),
                    ),
                  ),
                ],
              );
            },
          );
          return res;
        }
        return null;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: .5),
          ),
        ),
        child: Card(
          elevation: 0,
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── GAMBAR ───
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: item.photo ?? '',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ─── TEKS ───
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/author.svg',
                            height: 18,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${item.author} • ${formatDate(item.date ?? "")}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ─── AKSI & KATEGORI ───
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (item.category != null && item.category != "")
                          Container(
                            width: 70,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: PortalColors.jtvJingga,
                            ),
                            child: Text(
                              item.category!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: PortalColors.white,
                                  ),
                            ),
                          )
                        else
                          const SizedBox(),
                        SizedBox(
                          width: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Tombol Hapus (Pengganti Bookmark)
                              GestureDetector(
                                onTap: onDelete,
                                child: const Icon(
                                  Icons.bookmark,
                                  color: PortalColors.jtvJingga,
                                  size: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final url = 'https://portaljtv.com/${item.seoCategory}/${item.seo}';
                                  SharePlus.instance.share(
                                    ShareParams(
                                      uri: Uri.parse(url),
                                      subject: item.title,
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/icons/export-card.png',
                                  height: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
