// ── favorites_screen.dart ────────────────────────────────────────────────────
import 'package:doc_time/provider/app_state_provider.dart';
import 'package:doc_time/screens/doctor_details_screen.dart';
import 'package:doc_time/theme_colors/app_theme.dart';
import 'package:doc_time/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final favorites = provider.favoriteDoctors;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        automaticallyImplyLeading: false,
        title: const Text('Mes favoris'),
        actions: [
          if (favorites.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: const Text('Tout effacer',
                  style: TextStyle(color: AppColors.accent, fontSize: 13)),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                        color: Color(0xFFFFEBEB), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border,
                        size: 48, color: AppColors.accent),
                  ),
                  const SizedBox(height: 16),
                  const Text('Aucun médecin favori',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMedium)),
                  const SizedBox(height: 6),
                  const Text('Ajoutez des médecins à vos favoris',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) => DoctorListTile(
                doctor: favorites[index],
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            DoctorDetailScreen(doctor: favorites[index]))),
                onFavorite: () => provider.toggleFavorite(favorites[index].id),
              ),
            ),
    );
  }
}
