import 'package:flutter/material.dart';
import 'package:portal_jtv/features/home/presentation/bloc/home_state.dart';

Widget buildBreakingNewsSection(HomeState state) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔴 BREAKING NEWS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 8),
        ...state.breakingNews.map((news) => Text('• ${news.title}')),
      ],
    ),
  );
}
