import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/app_state_provider.dart';
import '../data/app_data.dart';
import '../theme_colors/app_theme.dart';
import '../widgets/widget.dart';
import 'doctor_details_screen.dart';
import 'specialistes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = AppData.currentUser;
    final popularDoctors = AppData.doctors.take(4).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bonjour, ${user.name.split(' ').first} ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Trouvez votre médecin idéal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  user.avatarUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.person,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.primary, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Search bar
                      GestureDetector(
                        onTap: () {
                          context.read<AppProvider>().setNavIndex(1);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search,
                                  color: AppColors.textLight, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Rechercher médecin, spécialité...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Stats banner ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        child: StatBadge(
                            icon: AppData.categories[0].icon,
                            value: '200+',
                            label: 'Médecins',
                            color: AppColors.primary)),
                    Flexible(
                        child: StatBadge(
                            icon: AppData.categories[1].icon,
                            value: '50+',
                            label: 'Cliniques',
                            color: AppColors.secondary)),
                    Flexible(
                        child: StatBadge(
                            icon: AppData.categories[2].icon,
                            value: '4.8',
                            label: 'Note moy.',
                            color: AppColors.warning)),
                    Flexible(
                        child: StatBadge(
                            icon: AppData.categories[3].icon,
                            value: '10k+',
                            label: 'Patients',
                            color: AppColors.accent)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── Categories ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Spécialités',
                actionLabel: 'Voir tout',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SpecialistsScreen()),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: AppData.categories.length,
                itemBuilder: (context, index) {
                  final cat = AppData.categories[index];
                  return CategoryGridCard(
                    category: cat,
                    onTap: () {
                      provider.setSelectedCategory(cat.name);
                      context.read<AppProvider>().setNavIndex(1);
                    },
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── Popular Doctors ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Médecins populaires',
                actionLabel: 'Voir tout',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SpecialistsScreen()),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 230,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: popularDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = popularDoctors[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 160,
                      child: DoctorCard(
                        doctor: doctor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  DoctorDetailScreen(doctor: doctor)),
                        ),
                        onFavorite: () => provider.toggleFavorite(doctor.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── Available Doctors ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Disponibles maintenant',
                actionLabel: 'Tous',
                onAction: () => context.read<AppProvider>().setNavIndex(1),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final doctor =
                    AppData.doctors.where((d) => d.isAvailable).toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DoctorListTile(
                    doctor: doctor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DoctorDetailScreen(doctor: doctor)),
                    ),
                    onFavorite: () => provider.toggleFavorite(doctor.id),
                  ),
                );
              },
              childCount: AppData.doctors.where((d) => d.isAvailable).length > 3
                  ? 3
                  : AppData.doctors.where((d) => d.isAvailable).length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
