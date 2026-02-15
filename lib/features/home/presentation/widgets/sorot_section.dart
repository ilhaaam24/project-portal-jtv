import 'package:flutter/material.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_state.dart';

Widget buildSorotSection(HomeState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '🔦 Sorotan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.sorot.length,
          itemBuilder: (context, index) {
            final sorot = state.sorot[index];
            return Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      sorot.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: Colors.grey),
                    ),
                    Container(color: Colors.black38),
                    Center(
                      child: Text(
                        sorot.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
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
