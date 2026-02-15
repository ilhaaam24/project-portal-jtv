import 'package:flutter/material.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_state.dart';

Widget buildHeadlinesSection(HomeState state) {
  return SizedBox(
    height: 200,
    child: PageView.builder(
      itemCount: state.headlines.length,
      itemBuilder: (context, index) {
        final headline = state.headlines[index];
        return Card(
          margin: const EdgeInsets.all(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                headline.photo,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: Colors.grey),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  headline.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
