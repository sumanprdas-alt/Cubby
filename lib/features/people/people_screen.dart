import 'package:flutter/material.dart';
import 'package:cubby/core/theme.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 20),
          Text('People', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),

          _SectionLabel('FAMILY'),
          const SizedBox(height: 10),
          _ListCard(
            children: [
              _PersonRow(name: 'Arjun', role: 'Parent', initial: 'A', color: AppColors.memberColors[0]),
              _PersonRow(name: 'Priya', role: 'Parent', initial: 'P', color: AppColors.memberColors[1]),
              _PersonRow(name: 'Ria', role: 'Child', initial: 'R', color: AppColors.memberColors[2]),
              _PersonRow(name: 'Buddy', role: 'Dog 🐾', initial: 'B', color: AppColors.memberColors[3], isLast: true),
            ],
          ),
          const SizedBox(height: 20),

          _SectionLabel('VEHICLES'),
          const SizedBox(height: 10),
          _ListCard(
            children: [
              _ItemRow(icon: '🚗', title: 'Toyota Camry 2022', subtitle: 'DXB A-12345 · Exp Oct 2026', isLast: true),
            ],
          ),
          const SizedBox(height: 20),

          _SectionLabel('PROPERTIES'),
          const SizedBox(height: 10),
          _ListCard(
            children: [
              _ItemRow(icon: '🏠', title: 'Marina Apt 1204', subtitle: 'Rent · Ejari ends Mar 2027', isLast: true),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.ink2,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final List<Widget> children;
  const _ListCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}

class _PersonRow extends StatelessWidget {
  final String name;
  final String role;
  final String initial;
  final Color color;
  final bool isLast;

  const _PersonRow({
    required this.name,
    required this.role,
    required this.initial,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color,
              child: Text(
                initial,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.ink)),
                  Text(role, style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _ItemRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}
