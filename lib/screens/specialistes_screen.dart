import 'package:doc_time/provider/app_state_provider.dart';
import 'package:doc_time/screens/doctor_details_screen.dart';
import 'package:doc_time/theme_colors/app_theme.dart';
import 'package:doc_time/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_data.dart';

class SpecialistsScreen extends StatelessWidget {
  const SpecialistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tous les spécialistes'),
        backgroundColor: AppColors.cardWhite,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: AppColors.cardWhite,
            height: 56,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              scrollDirection: Axis.horizontal,
              itemCount: AppData.categories.length,
              itemBuilder: (context, i) => CategoryChip(
                category: AppData.categories[i],
                isSelected:
                    provider.selectedCategory == AppData.categories[i].name,
                onTap: () =>
                    provider.setSelectedCategory(AppData.categories[i].name),
              ),
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${provider.filteredDoctors.length} médecins trouvés',
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: provider.filteredDoctors.isEmpty
                ? const Center(
                    child: Text('Aucun médecin dans cette catégorie'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    itemCount: provider.filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = provider.filteredDoctors[index];
                      return DoctorListTile(
                        doctor: doctor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  DoctorDetailScreen(doctor: doctor)),
                        ),
                        onFavorite: () => provider.toggleFavorite(doctor.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
