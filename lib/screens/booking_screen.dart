import 'package:doc_time/model/models.dart';
import 'package:doc_time/provider/app_state_provider.dart';
import 'package:doc_time/screens/confirmations_screen.dart';
import 'package:doc_time/theme_colors/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedSlot;

  List<String> get _availableSlots {
    if (_selectedDay == null) return [];
    final key =
        '${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}';
    return widget.doctor.availableSlots[key] ?? _generateDefaultSlots();
  }

  List<String> _generateDefaultSlots() {
    return [
      '08:00',
      '08:30',
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00'
    ];
  }

  bool get _canBook => _selectedDay != null && _selectedSlot != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Prendre rendez-vous'),
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Doctor mini card ─────────────────────────────────────
                  Container(
                    color: AppColors.cardWhite,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.doctor.imageUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 64,
                              height: 64,
                              color: AppColors.primaryLight,
                              child: const Icon(Icons.person,
                                  color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.doctor.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark)),
                              Text(widget.doctor.specialty,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.attach_money,
                                      size: 14, color: AppColors.secondary),
                                  Text(
                                    '${widget.doctor.consultationFee.toStringAsFixed(0)} FCFA',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Calendar ─────────────────────────────────────────────
                  Container(
                    color: AppColors.cardWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 60)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                          _selectedSlot = null;
                        });
                      },
                      enabledDayPredicate: (day) {
                        final weekday = day.weekday;
                        return weekday != DateTime.sunday;
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark),
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: AppColors.primary),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: AppColors.primary),
                      ),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            shape: BoxShape.circle),
                        todayTextStyle: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700),
                        selectedTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        defaultTextStyle:
                            const TextStyle(color: AppColors.textDark),
                        weekendTextStyle:
                            const TextStyle(color: AppColors.accent),
                        disabledTextStyle:
                            const TextStyle(color: AppColors.border),
                        outsideTextStyle:
                            const TextStyle(color: AppColors.textLight),
                        markerDecoration: const BoxDecoration(
                            color: AppColors.secondary, shape: BoxShape.circle),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight),
                        weekendStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Time slots ───────────────────────────────────────────
                  if (_selectedDay != null) ...[
                    Container(
                      color: AppColors.cardWhite,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Créneaux disponibles',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 12),
                          _availableSlots.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Text(
                                        'Aucun créneau disponible ce jour',
                                        style: TextStyle(
                                            color: AppColors.textLight)),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 2.2,
                                  ),
                                  itemCount: _availableSlots.length,
                                  itemBuilder: (context, index) {
                                    final slot = _availableSlots[index];
                                    final isSelected = _selectedSlot == slot;
                                    return GestureDetector(
                                      onTap: () =>
                                          setState(() => _selectedSlot = slot),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.primaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.primary
                                                    .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            slot,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.primary, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Sélectionnez une date pour voir les créneaux disponibles',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── Bottom CTA ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                if (_canBook) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}  •  $_selectedSlot',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canBook ? _confirmBooking : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.border,
                    ),
                    child: const Text(
                      'Confirmer le rendez-vous',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() {
    final provider = context.read<AppProvider>();
    final appointment = Appointment(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      doctor: widget.doctor,
      date: _selectedDay!,
      timeSlot: _selectedSlot!,
      status: AppointmentStatus.upcoming,
      fee: widget.doctor.consultationFee,
    );
    provider.addAppointment(appointment);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => ConfirmationScreen(appointment: appointment)),
    );
  }
}
