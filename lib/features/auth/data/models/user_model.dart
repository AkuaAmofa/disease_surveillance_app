class UserModel {
  final int id;
  final String name;
  final String email;
  final String url;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.url = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    var id = json['id'] as int? ?? 0;

    // Backend UserSerializer only returns {name, url}; extract PK from URL.
    if (id == 0 && url.isNotEmpty) {
      final match = RegExp(r'/users/(\d+)/').firstMatch(url);
      if (match != null) {
        id = int.parse(match.group(1)!);
      }
    }

    return UserModel(
      id: id,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      url: url,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
