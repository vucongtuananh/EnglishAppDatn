

class TopicModel {
  final int? id;
  final String category_name;
  final String? image;
  final String? color;
  final String? note;
  final int status;
  final int progress_percent;


  TopicModel({
    this.id,
    required this.category_name,
    this.image,
    this.color,
    this.note,
    this.status = 0,
    this.progress_percent = 0,

  });

  // Factory constructor to create a TopicModel from JSON
  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      category_name: json['category_name'],
      image: json['image'],
      color: json['color'],
      note: json['note'],
      status: json['status'] ?? 0,
      progress_percent: json['progress_percent'] ?? 0,
    );
  }

  // Convert TopicModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': category_name,
      'image': image,
      'color': color,
      'note': note,
      'status': status,
      'progress_percent': progress_percent,
    };
  }

  // Create a copy of TopicModel with optional parameter updates
  TopicModel copyWith({
    int? id,
    String? category_name,
    String? image,
    String? color,
    String? note,
    int? status,
    int? progress_percent,
  }) {
    return TopicModel(
      id: id ?? this.id,
      category_name: category_name ?? this.category_name,
      image: image ?? this.image,
      color: color ?? this.color,
      note: note ?? this.note,
      status: status ?? this.status,
      progress_percent: progress_percent ?? this.progress_percent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TopicModel && other.id == id && other.category_name == category_name && other.image == image && other.color == color && other.note == note && other.status == status && other.progress_percent == progress_percent;
  }

  @override
  int get hashCode {
    return id.hashCode ^ category_name.hashCode ^ image.hashCode ^ color.hashCode ^ note.hashCode ^ status.hashCode ^ progress_percent.hashCode;
  }

  @override
  String toString() {
    return 'TopicModel(id: $id, category_name: $category_name, image: $image, color: $color, note: $note, status: $status, progress_percent: $progress_percent)';
  }
}
