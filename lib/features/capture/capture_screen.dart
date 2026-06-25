import 'package:flutter/material.dart';
import 'package:cubby/core/theme.dart';

class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Cubby it', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            const Text(
              'Grab any family document',
              style: TextStyle(fontSize: 14, color: AppColors.ink2),
            ),
            const SizedBox(height: 28),
            _CaptureOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take a photo',
              subtitle: 'Camera with edge detection',
              color: AppColors.primarySoft,
              iconColor: AppColors.primary,
              onTap: () {
                // TODO: open camera
              },
            ),
            const SizedBox(height: 10),
            _CaptureOption(
              icon: Icons.photo_library_rounded,
              title: 'Pick from gallery',
              subtitle: 'Select up to 10 at once',
              color: AppColors.blueSoft,
              iconColor: AppColors.blue,
              onTap: () {
                // TODO: open gallery picker
              },
            ),
            const SizedBox(height: 10),
            _CaptureOption(
              icon: Icons.ios_share_rounded,
              title: 'Share from any app',
              subtitle: 'WhatsApp → Share → Cubby',
              color: AppColors.amberSoft,
              iconColor: AppColors.amber,
              onTap: () {
                // Info only — share sheet is system-level
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Text(
                'Passport, visa, prescription, school report,\nEjari, Mulkiya — anything. AI reads and sorts it.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.ink3, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _CaptureOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: AppColors.ink2),
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
