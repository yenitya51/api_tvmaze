class Show {
  final int id;
  final String name;
  final String? imageMedium;
  final String? summary;

  Show({
    required this.id,
    required this.name,
    this.imageMedium,
    this.summary,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      name: json['name'],
      imageMedium: json['image'] != null ? json['image']['medium'] : null,
      summary: json['summary'],
    );
  }
}
