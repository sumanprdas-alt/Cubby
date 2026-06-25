import 'package:flutter/material.dart';
import 'package:cubby/core/theme.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Ask Cubby', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),

            const Text(
              'Try asking',
              style: TextStyle(fontSize: 13, color: AppColors.ink2),
            ),
            const SizedBox(height: 12),

            _SuggestionChip('When does our visa expire?'),
            _SuggestionChip("Show me Buddy's vaccination records"),
            _SuggestionChip('What insurance do we have?'),
            _SuggestionChip('Which documents expire this year?'),

            const Spacer(),

            // Input bar
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ask about your family...',
                      style: TextStyle(fontSize: 14, color: AppColors.ink3),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  const _SuggestionChip(this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: send query to assistant
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, color: AppColors.primary),
        ),
      ),
    );
  }
}
