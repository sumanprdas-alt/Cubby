import 'package:flutter/material.dart';
import 'package:cubby/core/theme.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Inbox', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            const Text(
              'No items to review',
              style: TextStyle(fontSize: 13, color: AppColors.ink2),
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded, size: 48, color: AppColors.ink3.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  const Text(
                    'Your cubby is tidy',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.ink2),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Capture a document to see it here',
                    style: TextStyle(fontSize: 13, color: AppColors.ink3),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
