import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cubby/core/theme.dart';
import 'package:cubby/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyAsync = ref.watch(currentFamilyProvider);
    final membersAsync = ref.watch(familyMembersProvider);

    return familyAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (family) {
        if (family == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/onboarding');
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 20),
              const Text('Good morning', style: TextStyle(fontSize: 13, color: AppColors.ink2)),
              const SizedBox(height: 2),
              Text(family.name, style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, size: 18, color: AppColors.ink3),
                      SizedBox(width: 10),
                      Text('Ask anything or search...', style: TextStyle(fontSize: 14, color: AppColors.ink3)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              membersAsync.when(
                loading: () => const SizedBox(height: 72),
                error: (_, __) => const SizedBox(height: 72),
                data: (members) => SizedBox(
                  height: 72,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...members.map((m) => _MemberAvatar(
                        name: m.name,
                        initial: m.name[0].toUpperCase(),
                        color: _parseColor(m.avatarColor),
                        isPet: m.type == 'pet',
                      )),
                      _AddMemberButton(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const _SectionLabel('UPCOMING'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.notifications_none_rounded, size: 32, color: AppColors.ink3),
                    SizedBox(height: 8),
                    Text('No upcoming reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink2)),
                    SizedBox(height: 4),
                    Text('Cubby a document with a date and reminders will appear here', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColors.ink3)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const _SectionLabel('RECENTLY ADDED'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inbox_rounded, size: 32, color: AppColors.ink3),
                    SizedBox(height: 8),
                    Text('No documents yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink2)),
                    SizedBox(height: 4),
                    Text('Tap the camera button to cubby your first document', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColors.ink3)),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.memberColors[0];
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.memberColors[0];
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.ink2, letterSpacing: 0.3));
  }
}

class _MemberAvatar extends StatelessWidget {
  final String name;
  final String initial;
  final Color color;
  final bool isPet;
  const _MemberAvatar({required this.name, required this.initial, required this.color, this.isPet = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(radius: 23, backgroundColor: color, child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
          const SizedBox(height: 6),
          Text(isPet ? '$name 🐾' : name, style: const TextStyle(fontSize: 11, color: AppColors.ink2)),
        ],
      ),
    );
  }
}

class _AddMemberButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(radius: 23, backgroundColor: AppColors.border, child: const Icon(Icons.add, size: 20, color: AppColors.ink2)),
          const SizedBox(height: 6),
          const Text('Add', style: TextStyle(fontSize: 11, color: AppColors.ink3)),
        ],
      ),
    );
  }
}
