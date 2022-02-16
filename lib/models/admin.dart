class Admin {
  String token;

  Admin({required this.token});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(token: json['token']);
  }

  toJson() {
    return {'token': token};
  }
}
