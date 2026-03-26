import 'package:doc_time/provider/app_state_provider.dart';
import 'package:doc_time/screens/doctor_details_screen.dart';
import 'package:doc_time/theme_colors/app_theme.dart';
import 'package:doc_time/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Recherche'),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.cardWhite,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: AppSearchBar(
              controller: _controller,
              onChanged: (v) => provider.setSearchQuery(v),
              onFilter: () => _showFilterSheet(context),
            ),
          ),

          // Category chips
          Container(
            color: AppColors.cardWhite,
            height: 52,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          const SizedBox(height: 1),

          // Results
          Expanded(
            child: provider.filteredDoctors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 60, color: AppColors.textLight),
                        const SizedBox(height: 12),
                        const Text(
                          'Aucun médecin trouvé',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Modifiez votre recherche ou les filtres',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textLight),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            _controller.clear();
                            provider.clearSearch();
                          },
                          child: const Text('Réinitialiser la recherche'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  double _minRating = 0;
  bool _availableOnly = false;
  String _sortBy = 'Note';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtrer & Trier',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: AppColors.border, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Note minimale',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _minRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _minRating = v),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(_minRating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Trier par',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: ['Note', 'Expérience', 'Tarif', 'Popularité']
                .map(
                  (s) => ChoiceChip(
                    label: Text(s),
                    selected: _sortBy == s,
                    onSelected: (_) => setState(() => _sortBy = s),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _sortBy == s ? Colors.white : AppColors.textMedium,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: _availableOnly,
            onChanged: (v) => setState(() => _availableOnly = v),
            title: const Text('Disponibles uniquement',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Appliquer les filtres'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
