class AuthTokenModel {
  final String token;

  const AuthTokenModel({required this.token});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(token: json['token'] as String);
  }
}
