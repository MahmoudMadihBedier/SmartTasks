class Project {
  final int id;
  final String title;
  final String description;

  Project({required this.id, required this.title, required this.description});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );
  }
}
