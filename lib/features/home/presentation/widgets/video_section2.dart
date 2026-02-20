// lib/features/home/presentation/widgets/video_section.dart

import 'package:flutter/material.dart';
import 'package:portal_jtv/features/home/presentation/widgets/tittle_section.dart';
import '../../domain/entities/video_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoSection extends StatelessWidget {
  final List<VideoEntity> videos;

  const VideoSection({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: TittleSection(title: 'Video Terbaru'),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return GestureDetector(
                onTap: () {
                  // Navigate ke video player / YouTube
                },
                child: Container(
                  width: 200,
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.network(
                              video.thumbnail,
                              width: 200,
                              height: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 200,
                                height: 110,
                                color: Colors.grey[300],
                                child: const Icon(Icons.videocam),
                              ),
                            ),
                            // Play button overlay
                            Positioned(
                              top: 6,
                              left: 6,

                              child: SvgPicture.asset(
                                'assets/icons/play.svg',
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Title
                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
