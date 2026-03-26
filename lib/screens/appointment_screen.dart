import 'package:doc_time/provider/app_state_provider.dart';
import 'package:doc_time/theme_colors/app_theme.dart';
import 'package:doc_time/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        automaticallyImplyLeading: false,
        title: const Text('Mes rendez-vous'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('À venir'),
                  if (provider.upcomingAppointments.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '${provider.upcomingAppointments.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Terminés'),
            const Tab(text: 'Annulés'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AppointmentList(
            appointments: provider.upcomingAppointments,
            emptyMessage: 'Aucun rendez-vous à venir',
            emptySubMessage: 'Réservez une consultation avec un médecin',
            emptyIcon: Icons.calendar_today_outlined,
            onCancel: (id) => _confirmCancel(context, id),
          ),
          _AppointmentList(
            appointments: provider.completedAppointments,
            emptyMessage: 'Aucune consultation terminée',
            emptyIcon: Icons.check_circle_outline,
          ),
          _AppointmentList(
            appointments: provider.cancelledAppointments,
            emptyMessage: 'Aucun rendez-vous annulé',
            emptyIcon: Icons.cancel_outlined,
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Annuler le rendez-vous',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        content:
            const Text('Êtes-vous sûr de vouloir annuler ce rendez-vous ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Non, garder',
                style: TextStyle(color: AppColors.textMedium)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().cancelAppointment(appointmentId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rendez-vous annulé'),
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Oui, annuler',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final List appointments;
  final String emptyMessage;
  final String? emptySubMessage;
  final IconData emptyIcon;
  final Function(String)? onCancel;

  const _AppointmentList({
    required this.appointments,
    required this.emptyMessage,
    this.emptySubMessage,
    required this.emptyIcon,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(emptyIcon, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(emptyMessage,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMedium)),
            if (emptySubMessage != null) ...[
              const SizedBox(height: 6),
              Text(emptySubMessage!,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textLight)),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) => AppointmentCard(
        appointment: appointments[index],
        onCancel:
            onCancel != null ? () => onCancel!(appointments[index].id) : null,
      ),
    );
  }
}
