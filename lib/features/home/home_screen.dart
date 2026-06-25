import 'package:flutter/material.dart';
import 'package:cubby/core/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 20),
          // Greeting
          Text(
            'Good morning',
            style: TextStyle(fontSize: 13, color: AppColors.ink2),
          ),
          const SizedBox(height: 2),
          Text(
            'The Sharma Family',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),

          // Search bar
          GestureDetector(
            onTap: () {
              // TODO: navigate to search
            },
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
                  Text(
                    'Ask anything or search...',
                    style: TextStyle(fontSize: 14, color: AppColors.ink3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Family member avatars
          SizedBox(
            height: 72,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _MemberAvatar(name: 'Arjun', initial: 'A', color: AppColors.memberColors[0]),
                _MemberAvatar(name: 'Priya', initial: 'P', color: AppColors.memberColors[1]),
                _MemberAvatar(name: 'Ria', initial: 'R', color: AppColors.memberColors[2]),
                _MemberAvatar(name: 'Buddy', initial: 'B', color: AppColors.memberColors[3]),
                _AddMemberButton(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Upcoming reminders
          _SectionLabel('UPCOMING'),
          const SizedBox(height: 10),
          _ReminderCard(
            icon: '🛂',
            title: "Arjun's visa expires",
            subtitle: 'in 23 days',
            urgent: true,
          ),
          _ReminderCard(
            icon: '💉',
            title: "Buddy's vaccination due",
            subtitle: 'in 12 days',
            urgent: false,
          ),
          _ReminderCard(
            icon: '🚗',
            title: 'Car insurance renewal',
            subtitle: 'in 47 days',
            urgent: false,
          ),
          const SizedBox(height: 24),

          // Recently added
          _SectionLabel('RECENTLY ADDED'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Column(
              children: [
                _RecentItem(
                  icon: '📄',
                  title: "Ria's term 2 report",
                  subtitle: 'School report · Today',
                  memberInitial: 'R',
                  memberColor: AppColors.memberColors[2],
                ),
                const Divider(),
                _RecentItem(
                  icon: '💊',
                  title: 'Dr. Khan prescription',
                  subtitle: 'Prescription · Yesterday',
                  memberInitial: 'A',
                  memberColor: AppColors.memberColors[0],
                ),
                const Divider(),
                _RecentItem(
                  icon: '🚗',
                  title: 'Mulkiya — Toyota Camry',
                  subtitle: 'Vehicle reg · 2 days ago',
                  memberInitial: 'A',
                  memberColor: AppColors.memberColors[0],
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Bottom padding for nav bar
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

class _MemberAvatar extends StatelessWidget {
  final String name;
  final String initial;
  final Color color;
  const _MemberAvatar({required this.name, required this.initial, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: color,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 11, color: AppColors.ink2),
          ),
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
          CircleAvatar(
            radius: 23,
            backgroundColor: AppColors.border,
            child: const Icon(Icons.add, size: 20, color: AppColors.ink2),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add',
            style: TextStyle(fontSize: 11, color: AppColors.ink3),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool urgent;

  const _ReminderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.urgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: urgent ? AppColors.amberSoft : AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: urgent ? null : Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: urgent ? AppColors.amber : AppColors.ink2,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.ink3),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String memberInitial;
  final Color memberColor;
  final bool isLast;

  const _RecentItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.memberInitial,
    required this.memberColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
              ],
            ),
          ),
          CircleAvatar(
            radius: 11,
            backgroundColor: memberColor,
            child: Text(
              memberInitial,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
