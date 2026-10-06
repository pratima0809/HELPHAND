import 'package:cloud_firestore/cloud_firestore.dart';

class Signup {
  final String id;
  final String userId;
  final String opportunityId;
  final String opportunityTitle;
  final String organizationName;
  final String category;
  final String date;
  final String location;
  final String volunteerName;
  final String email;
  final String phone;
  final String availability;
  final String skills;
  final String reason;
  final String status;
  final DateTime createdAt;

  Signup({
    required this.id,
    required this.userId,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.organizationName,
    required this.category,
    required this.date,
    required this.location,
    required this.volunteerName,
    required this.email,
    required this.phone,
    required this.availability,
    required this.skills,
    required this.reason,
    this.status = 'Confirmed',
    required this.createdAt,
  });

  factory Signup.fromFirestore(String id, Map<String, dynamic> data) {
    return Signup(
      id: id,
      userId: data['userId'] ?? '',
      opportunityId: data['opportunityId'] ?? '',
      opportunityTitle: data['opportunityTitle'] ?? '',
      organizationName: data['organizationName'] ?? '',
      category: data['category'] ?? '',
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      volunteerName: data['volunteerName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      availability: data['availability'] ?? '',
      skills: data['skills'] ?? '',
      reason: data['reason'] ?? '',
      status: data['status'] ?? 'Confirmed',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'organizationName': organizationName,
      'category': category,
      'date': date,
      'location': location,
      'volunteerName': volunteerName,
      'email': email,
      'phone': phone,
      'availability': availability,
      'skills': skills,
      'reason': reason,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
