class NotifyEntity {
  final String title;
  final String body;
  final int createdAt;
  final bool isNew;

  NotifyEntity(
      {required this.title,
      required this.body,
      required this.createdAt,
      required this.isNew});

  factory NotifyEntity.fromJson(Map<String, dynamic> json) {
    return NotifyEntity(
        title: json['title'],
        body: json['body'],
        createdAt: json['created_at'],
        isNew: json['is_new']);
  }

  @override
  String toString() {
    return 'NotifyEntity{title: $title, body: $body, createdAt: $createdAt, isNew: $isNew}';
  }
}
