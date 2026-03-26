import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final String clinicName;
  final String address;
  final String city;
  final String phone;
  final String bio;
  final double consultationFee;
  final bool isAvailable;
  final bool isFavorite;
  final List<String> availableDays;
  final Map<String, List<String>> availableSlots;
  final String category;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.clinicName,
    required this.address,
    required this.city,
    required this.phone,
    required this.bio,
    required this.consultationFee,
    this.isAvailable = true,
    this.isFavorite = false,
    required this.availableDays,
    required this.availableSlots,
    required this.category,
  });

  Doctor copyWith({
    String? id,
    String? name,
    String? specialty,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? experienceYears,
    String? clinicName,
    String? address,
    String? city,
    String? phone,
    String? bio,
    double? consultationFee,
    bool? isAvailable,
    bool? isFavorite,
    List<String>? availableDays,
    Map<String, List<String>>? availableSlots,
    String? category,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      experienceYears: experienceYears ?? this.experienceYears,
      clinicName: clinicName ?? this.clinicName,
      address: address ?? this.address,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      consultationFee: consultationFee ?? this.consultationFee,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      availableDays: availableDays ?? this.availableDays,
      availableSlots: availableSlots ?? this.availableSlots,
      category: category ?? this.category,
    );
  }
}

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime date;
  final String timeSlot;
  final AppointmentStatus status;
  final String? notes;
  final double fee;

  Appointment({
    required this.id,
    required this.doctor,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.notes,
    required this.fee,
  });

  Appointment copyWith({
    String? id,
    Doctor? doctor,
    DateTime? date,
    String? timeSlot,
    AppointmentStatus? status,
    String? notes,
    double? fee,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      fee: fee ?? this.fee,
    );
  }
}

enum AppointmentStatus { upcoming, completed, cancelled }

class MedicalCategory {
  final String id;
  final String name;
  final FaIconData icon;
  final List<int> gradientColors;

  MedicalCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.gradientColors,
  });
}

class Review {
  final String id;
  final String patientName;
  final String patientAvatar;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.patientName,
    required this.patientAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String bloodType;
  final String avatarUrl;
  final List<String> allergies;
  final List<String> chronicDiseases;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.bloodType,
    required this.avatarUrl,
    this.allergies = const [],
    this.chronicDiseases = const [],
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? bloodType,
    String? avatarUrl,
    List<String>? allergies,
    List<String>? chronicDiseases,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodType: bloodType ?? this.bloodType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
    );
  }
}
