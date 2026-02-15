import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/utils/text_size_preferences.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_size_cubit.dart';

void showTextSizeSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<TextSizeCubit>(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<TextSizeCubit, double>(
            builder: (ctx, fontSize) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ukuran Teks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.text_decrease),
                        onPressed: () => ctx.read<TextSizeCubit>().decrease(),
                      ),
                      Text(
                        '${fontSize.toInt()}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.text_increase),
                        onPressed: () => ctx.read<TextSizeCubit>().increase(),
                      ),
                    ],
                  ),
                  Slider(
                    value: fontSize,
                    min: TextSizePreferences.minSize,
                    max: TextSizePreferences.maxSize,
                    divisions: 8,
                    label: '${fontSize.toInt()}',
                    onChanged: (val) => ctx.read<TextSizeCubit>().setSize(val),
                  ),
                  TextButton(
                    onPressed: () => ctx.read<TextSizeCubit>().reset(),
                    child: const Text('Reset ke Default'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
