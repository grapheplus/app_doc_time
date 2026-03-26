import 'package:doc_time/theme_colors/app_theme.dart';
import 'package:flutter/material.dart';
import '../data/app_data.dart';
// import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A8CFF), Color(0xFF0055CC)],
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mon profil',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              user.avatarUrl,
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(Icons.person,
                                    color: Colors.white, size: 44),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(user.name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(user.email,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _HeaderStat(label: 'Rendez-vous', value: '12'),
                          Container(
                              width: 0.8,
                              height: 36,
                              color: Colors.white.withOpacity(0.3)),
                          _HeaderStat(label: 'Médecins', value: '5'),
                          Container(
                              width: 0.8,
                              height: 36,
                              color: Colors.white.withOpacity(0.3)),
                          _HeaderStat(label: 'Avis donnés', value: '8'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 20)),

          // ── Medical info ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informations médicales',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                            icon: Icons.bloodtype,
                            label: 'Groupe sanguin',
                            value: user.bloodType,
                            color: AppColors.accent),
                        const Divider(height: 20),
                        _InfoRow(
                            icon: Icons.cake,
                            label: 'Date de naissance',
                            value: user.dateOfBirth,
                            color: AppColors.primary),
                        const Divider(height: 20),
                        _InfoRow(
                            icon: Icons.phone,
                            label: 'Téléphone',
                            value: user.phone,
                            color: AppColors.secondary),
                        if (user.allergies.isNotEmpty) ...[
                          const Divider(height: 20),
                          _InfoRow(
                            icon: Icons.warning_amber,
                            label: 'Allergies',
                            value: user.allergies.join(', '),
                            color: AppColors.warning,
                          ),
                        ],
                        if (user.chronicDiseases.isNotEmpty) ...[
                          const Divider(height: 20),
                          _InfoRow(
                            icon: Icons.medical_information,
                            label: 'Maladies chroniques',
                            value: user.chronicDiseases.join(', '),
                            color: Color(0xFF8B5CF6),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 20)),

          // ── Menu ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Paramètres',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _MenuSection(
                    items: [
                      _MenuItem(
                          icon: Icons.person_outline,
                          label: 'Modifier le profil',
                          color: AppColors.primary),
                      _MenuItem(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          color: AppColors.secondary),
                      _MenuItem(
                          icon: Icons.security,
                          label: 'Confidentialité',
                          color: Color(0xFF8B5CF6)),
                      _MenuItem(
                          icon: Icons.language,
                          label: 'Langue',
                          color: AppColors.warning,
                          trailing: 'Français'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MenuSection(
                    items: [
                      _MenuItem(
                          icon: Icons.help_outline,
                          label: 'Aide & Support',
                          color: AppColors.textMedium),
                      _MenuItem(
                          icon: Icons.star_outline,
                          label: 'Évaluer l\'app',
                          color: AppColors.warning),
                      _MenuItem(
                          icon: Icons.share,
                          label: 'Partager l\'app',
                          color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MenuSection(
                    items: [
                      _MenuItem(
                          icon: Icons.logout,
                          label: 'Se déconnecter',
                          color: AppColors.accent,
                          isDestructive: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'DOC TIME v1.0.0\nFait avec ❤️ pour votre santé',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        Text(label,
            style:
                TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.75))),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textLight)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final index = e.key;
          final item = e.value;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, size: 20, color: item.color),
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: item.isDestructive
                        ? AppColors.accent
                        : AppColors.textDark,
                  ),
                ),
                trailing: item.trailing != null
                    ? Text(item.trailing!,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textLight))
                    : const Icon(Icons.chevron_right,
                        color: AppColors.textLight, size: 18),
                onTap: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              if (index < items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 0.8, color: AppColors.border),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDestructive;
  final String? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.isDestructive = false,
    this.trailing,
  });
}
