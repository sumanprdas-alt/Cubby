import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:cubby/core/theme.dart';
import 'package:cubby/providers/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final _familyNameController = TextEditingController();
  String? _familyId;
  bool _loading = false;
  final List<_MemberEntry> _members = [];
  int _colorIndex = 0;

  Future<void> _createFamily() async {
    if (_familyNameController.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final auth = FirebaseAuth.instance.currentUser;
    if (auth == null) return;
    final service = ref.read(familyServiceProvider);
    final familyId = await service.createFamily(
      name: _familyNameController.text.trim(),
      firebaseUid: auth.uid,
      phoneNumber: auth.phoneNumber,
      displayName: auth.displayName,
    );
    setState(() { _familyId = familyId; _step = 1; _loading = false; });
  }

  Future<void> _addMember(_MemberEntry entry) async {
    if (_familyId == null) return;
    final service = ref.read(familyServiceProvider);
    await service.addMember(
      familyId: _familyId!, name: entry.name, type: entry.type,
      role: entry.type == 'person' ? entry.role : null,
      species: entry.type == 'pet' ? entry.species : null,
      colorIndex: _colorIndex,
    );
    _colorIndex++;
  }

  Future<void> _finishOnboarding() async {
    setState(() => _loading = true);
    for (final member in _members) { await _addMember(member); }
    await ref.refresh(currentUserProvider.future);
    final family = await ref.refresh(currentFamilyProvider.future);
    ref.invalidate(familyMembersProvider);
    if (mounted && family != null) {
      context.go('/');
    } else if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      ref.invalidate(currentUserProvider);
      ref.invalidate(currentFamilyProvider);
      if (mounted) context.go('/');
    }
  }

  void _showAddMemberSheet() {
    final nameController = TextEditingController();
    String type = 'person'; String role = 'parent'; String species = 'dog';
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSheetState) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Add family member', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
          const SizedBox(height: 16),
          TextField(controller: nameController, autofocus: true, textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 15, color: AppColors.ink),
            decoration: InputDecoration(hintText: 'Name', hintStyle: const TextStyle(color: AppColors.ink3),
              filled: true, fillColor: AppColors.canvas, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border, width: 0.5)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border, width: 0.5)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1)))),
          const SizedBox(height: 16),
          Row(children: [
            _TypeChip(label: 'Person', icon: Icons.person, selected: type == 'person', onTap: () => setSheetState(() => type = 'person')),
            const SizedBox(width: 8),
            _TypeChip(label: 'Pet', icon: Icons.pets, selected: type == 'pet', onTap: () => setSheetState(() => type = 'pet')),
          ]),
          const SizedBox(height: 16),
          if (type == 'person') ...[
            const Text('Relationship', style: TextStyle(fontSize: 13, color: AppColors.ink2)), const SizedBox(height: 8),
            Wrap(spacing: 8, children: ['parent', 'child', 'grandparent', 'caregiver'].map((r) =>
              _SelectChip(label: r[0].toUpperCase() + r.substring(1), selected: role == r, onTap: () => setSheetState(() => role = r))).toList()),
          ] else ...[
            const Text('Species', style: TextStyle(fontSize: 13, color: AppColors.ink2)), const SizedBox(height: 8),
            Wrap(spacing: 8, children: ['dog', 'cat', 'bird', 'fish', 'other'].map((s) =>
              _SelectChip(label: s[0].toUpperCase() + s.substring(1), selected: species == s, onTap: () => setSheetState(() => species = s))).toList()),
          ],
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () { if (nameController.text.trim().isEmpty) return;
              setState(() { _members.add(_MemberEntry(name: nameController.text.trim(), type: type, role: role, species: species)); });
              Navigator.pop(ctx); },
            child: const Text('Add member'))),
        ]),
      )),
    );
  }

  @override
  void dispose() { _familyNameController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.canvas, body: SafeArea(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: _step == 0 ? _buildFamilyNameStep() : _buildAddMembersStep(),
    )));
  }

  Widget _buildFamilyNameStep() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 60),
    Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
      child: const Icon(Icons.all_inbox_rounded, color: Colors.white, size: 24)),
    const SizedBox(height: 24),
    const Text("Let's set up\nyour family", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: AppColors.ink, height: 1.2)),
    const SizedBox(height: 8),
    const Text('Give your family a name. You can change it later.', style: TextStyle(fontSize: 14, color: AppColors.ink2)),
    const SizedBox(height: 32),
    TextField(controller: _familyNameController, textCapitalization: TextCapitalization.words, autofocus: true,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink),
      decoration: InputDecoration(hintText: 'e.g. The Sharma Family', hintStyle: const TextStyle(color: AppColors.ink3, fontWeight: FontWeight.w400),
        filled: true, fillColor: AppColors.card, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 0.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 0.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1)))),
    const SizedBox(height: 24),
    SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: _loading ? null : _createFamily,
      child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Continue'))),
  ]);

  Widget _buildAddMembersStep() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 60),
    const Text("Who's in your family?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: AppColors.ink, height: 1.2)),
    const SizedBox(height: 8),
    const Text('Add people and pets. You can always add more later.', style: TextStyle(fontSize: 14, color: AppColors.ink2)),
    const SizedBox(height: 24),
    Expanded(child: ListView(children: [
      ..._members.asMap().entries.map((entry) { final i = entry.key; final m = entry.value;
        return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Row(children: [
            CircleAvatar(radius: 20, backgroundColor: AppColors.memberColors[i % AppColors.memberColors.length],
              child: Text(m.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.ink)),
              Text(m.type == 'pet' ? '${m.species![0].toUpperCase()}${m.species!.substring(1)} 🐾' : m.role![0].toUpperCase() + m.role!.substring(1),
                style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
            ])),
            GestureDetector(onTap: () => setState(() => _members.removeAt(i)), child: const Icon(Icons.close, size: 18, color: AppColors.ink3)),
          ]));
      }),
      GestureDetector(onTap: _showAddMemberSheet, child: Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary, width: 0.5)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add, size: 18, color: AppColors.primary), SizedBox(width: 8),
          Text('Add family member', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
        ]))),
    ])),
    Padding(padding: const EdgeInsets.only(bottom: 40), child: SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: _members.isEmpty ? null : (_loading ? null : _finishOnboarding),
      child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Text(_members.isEmpty ? 'Add at least one member' : 'Done — start using Cubby')))),
  ]);
}

class _MemberEntry { final String name; final String type; final String? role; final String? species;
  _MemberEntry({required this.name, required this.type, this.role, this.species}); }

class _TypeChip extends StatelessWidget {
  final String label; final IconData icon; final bool selected; final VoidCallback onTap;
  const _TypeChip({required this.label, required this.icon, required this.selected, required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(color: selected ? AppColors.primarySoft : AppColors.canvas, borderRadius: BorderRadius.circular(10),
      border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 0.5)),
    child: Row(children: [Icon(icon, size: 18, color: selected ? AppColors.primary : AppColors.ink3), const SizedBox(width: 8),
      Text(label, style: TextStyle(fontSize: 14, fontWeight: selected ? FontWeight.w500 : FontWeight.w400, color: selected ? AppColors.primary : AppColors.ink2))])));
}

class _SelectChip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _SelectChip({required this.label, required this.selected, required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(color: selected ? AppColors.primarySoft : AppColors.canvas, borderRadius: BorderRadius.circular(8),
      border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 0.5)),
    child: Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w500 : FontWeight.w400, color: selected ? AppColors.primary : AppColors.ink2))));
}
