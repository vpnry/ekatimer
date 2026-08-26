import 'package:ekatimer/models/user_profile.dart';
import 'package:ekatimer/providers/settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('migrates legacy name and manages multiple active profiles', () async {
    SharedPreferences.setMockInitialValues({'user_name': 'Original User'});
    final provider = SettingsProvider();

    await provider.loadSettings();
    expect(provider.profiles, hasLength(1));
    expect(provider.activeProfileId, UserProfile.defaultId);
    expect(provider.userName, 'Original User');

    final second = await provider.addUserProfile('Retreat');
    expect(provider.profiles, hasLength(2));
    expect(provider.activeProfileId, second.id);
    expect(provider.userName, 'Retreat');

    await provider.renameUserProfile(second.id, 'Morning Retreat');
    expect(provider.userName, 'Morning Retreat');

    await provider.selectUserProfile(UserProfile.defaultId);
    expect(provider.userName, 'Original User');

    await provider.deleteUserProfile(second.id);
    expect(provider.profiles.single.id, UserProfile.defaultId);
  });
}
