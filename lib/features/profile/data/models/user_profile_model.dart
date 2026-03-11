class UserProfile {
  final String name;
  final String email;
  final String initials;
  final String role;
  final String defaultRegion;
  final bool pushNotifications;
  final bool darkMode;

  const UserProfile({
    required this.name,
    required this.email,
    required this.initials,
    required this.role,
    required this.defaultRegion,
    required this.pushNotifications,
    required this.darkMode,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? initials,
    String? role,
    String? defaultRegion,
    bool? pushNotifications,
    bool? darkMode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      initials: initials ?? this.initials,
      role: role ?? this.role,
      defaultRegion: defaultRegion ?? this.defaultRegion,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  static const mock = UserProfile(
    name: 'Dr. Kwame Mensah',
    email: 'kwame.mensah@health.gov.gh',
    initials: 'KM',
    role: 'Epidemiologist',
    defaultRegion: 'Greater Accra',
    pushNotifications: true,
    darkMode: false,
  );
}
