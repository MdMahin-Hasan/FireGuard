import 'package:flutter/material.dart';

// --- Enums with behavior ---
enum MemberRole {
  owner,
  member;

  static MemberRole from(String v) =>
      MemberRole.values.firstWhere((r) => r.name == v, orElse: () => member);

  bool get isOwner => this == owner;
  MaterialColor get color => isOwner ? Colors.deepPurple : Colors.blue;
  String get label => name.toUpperCase();
}

enum MemberStatus {
  active,
  pending;

  static MemberStatus from(String v) =>
      MemberStatus.values.firstWhere((s) => s.name == v, orElse: () => active);

  bool get isPending => this == pending;
  Color get color => isPending ? Colors.orange : Colors.green;
  IconData get icon => isPending ? Icons.pending_outlined : Icons.check_circle_outline;
}

// --- Data Models ---
class UserProfile {
  final String id, name, email;
  UserProfile({required this.id, required this.name, required this.email});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['_id'] ?? '',
    name: json['name'] ?? 'Unknown',
    email: json['email'] ?? '',
  );

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';
}

class DeviceMember {
  final String id, deviceId;
  final UserProfile user;
  final MemberRole role;
  final MemberStatus status;
  final DateTime createdAt;

  DeviceMember({
    required this.id,
    required this.deviceId,
    required this.user,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory DeviceMember.fromJson(Map<String, dynamic> json) => DeviceMember(
    id: json['_id'] ?? '',
    deviceId: json['device'] ?? '',
    user: UserProfile.fromJson(json['user'] ?? {}),
    role: MemberRole.from(json['role'] ?? 'member'),
    status: MemberStatus.from(json['status'] ?? 'active'),
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}