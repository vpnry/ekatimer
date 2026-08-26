/// One local practitioner identity. Sessions are tagged with a profile id so
/// several people can share one device without mixing stats or history.
class UserProfile {
  /// Id assigned to the single profile that exists before the user creates
  /// any others, and to sessions recorded before multi-profile support
  /// existed — kept stable so old data stays attached to the right profile.
  static const String defaultId = 'default';

  final String id;
  final String name;

  const UserProfile({required this.id, required this.name});

  UserProfile copyWith({String? id, String? name}) =>
      UserProfile(id: id ?? this.id, name: name ?? this.name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString().trim() ?? '';
    final name = json['name']?.toString().trim() ?? '';
    if (id.isEmpty || name.isEmpty) {
      throw const FormatException('Profile id and name are required.');
    }
    return UserProfile(id: id, name: name);
  }
}
