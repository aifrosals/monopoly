class Template {
  String name;
  String imageUrl;
  int level;

  Template({required this.name, required this.imageUrl, required this.level});

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
        name: json['display_name'],
        imageUrl: json['image_url'],
        level: json['level']);
  }
}
