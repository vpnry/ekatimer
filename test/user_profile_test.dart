import 'package:ekatimer/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('profile JSON round-trip preserves stable id and display name', () {
    const profile = UserProfile(id: 'retreat', name: 'Retreat Practice');

    expect(UserProfile.fromJson(profile.toJson()).id, 'retreat');
    expect(UserProfile.fromJson(profile.toJson()).name, 'Retreat Practice');
  });

  test('profile JSON rejects blank identity fields', () {
    expect(
      () => UserProfile.fromJson({'id': '', 'name': 'Meditator'}),
      throwsFormatException,
    );
    expect(
      () => UserProfile.fromJson({'id': 'default', 'name': '  '}),
      throwsFormatException,
    );
  });
}
