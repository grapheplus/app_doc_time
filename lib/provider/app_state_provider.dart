import 'package:flutter/material.dart';
import '../model/models.dart';
import '../data/app_data.dart';

class AppProvider extends ChangeNotifier {
  final List<Doctor> _doctors = List.from(AppData.doctors);
  final List<Appointment> _appointments = [];
  final UserProfile _user = AppData.currentUser;
  int _currentNavIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = '';

  List<Doctor> get doctors => _doctors;
  List<Doctor> get favoriteDoctors =>
      _doctors.where((d) => d.isFavorite).toList();
  List<Appointment> get appointments => _appointments;
  List<Appointment> get upcomingAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.upcoming)
      .toList();
  List<Appointment> get completedAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.completed)
      .toList();
  List<Appointment> get cancelledAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.cancelled)
      .toList();
  UserProfile get user => _user;
  int get currentNavIndex => _currentNavIndex;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Doctor> get filteredDoctors {
    List<Doctor> result = _doctors;
    if (_selectedCategory.isNotEmpty) {
      result = result.where((d) => d.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((d) =>
              d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.specialty.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.city.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category == _selectedCategory ? '' : category;
    notifyListeners();
  }

  void toggleFavorite(String doctorId) {
    final index = _doctors.indexWhere((d) => d.id == doctorId);
    if (index != -1) {
      _doctors[index] = _doctors[index].copyWith(
        isFavorite: !_doctors[index].isFavorite,
      );
      notifyListeners();
    }
  }

  void addAppointment(Appointment appointment) {
    _appointments.insert(0, appointment);
    notifyListeners();
  }

  void cancelAppointment(String appointmentId) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _selectedCategory = '';
    notifyListeners();
  }
}
