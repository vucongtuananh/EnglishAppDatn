enum CategoryType {
  self_introduction(1, 'self_introduction', 'Giới thiệu bản thân'),
  daily_routines(2, 'daily_routines', 'Thói quen hàng ngày'),
  hobbies_and_interests(3, 'hobbies_and_interests', 'Sở thích và mối quan tâm'),
  family_members(4, 'family_members', 'Thành viên gia đình'),
  food_and_drinks(5, 'food_and_drinks', 'Thức ăn và đồ uống'),
  weather_and_seasons(6, 'weather_and_seasons', 'Thời tiết và mùa'),
  clothing_and_fashion(7, 'clothing_and_fashion', 'Quần áo và thời trang'),
  school_and_education(8, 'school_and_education', 'Trường học và giáo dục'),
  work_and_jobs(9, 'work_and_jobs', 'Công việc và nghề nghiệp'),
  shopping_and_money(10, 'shopping_and_money', 'Mua sắm và tiền bạc'),
  travel_and_sightseeing(11, 'travel_and_sightseeing', 'Du lịch và tham quan'),
  sports_and_exercise(12, 'sports_and_exercise', 'Thể thao và tập luyện'),
  technology_and_devices(13, 'technology_and_devices', 'Công nghệ và thiết bị'),
  movies_and_entertainment(14, 'movies_and_entertainment', 'Phim ảnh và giải trí'),
  health_and_fitness(15, 'health_and_fitness', 'Sức khỏe và thể hình'),
  animals_and_pets(16, 'animals_and_pets', 'Động vật và thú cưng'),
  holidays_and_festivals(17, 'holidays_and_festivals', 'Ngày lễ và lễ hội'),
  environment_and_nature(18, 'environment_and_nature', 'Môi trường và thiên nhiên'),
  dreams_and_future_plans(20, 'dreams_and_future_plans', 'Ước mơ và kế hoạch tương lai');

  final int id;
  final String categoryName;
  final String vietnameseName;

  const CategoryType(this.id, this.categoryName, this.vietnameseName);

  // Tìm CategoryType theo id
  static CategoryType? fromId(int id) {
    return CategoryType.values.firstWhere(
          (type) => type.id == id,
      orElse: () => throw Exception('Không tìm thấy CategoryType với id: $id'),
    );
  }

  // Tìm CategoryType theo categoryName
  static CategoryType? fromCategoryName(String name) {
    return CategoryType.values.firstWhere(
          (type) => type.categoryName == name,
      orElse: () => throw Exception('Không tìm thấy CategoryType với tên: $name'),
    );
  }

  // Lấy tên tiếng Việt
  String get getVietnameseName => vietnameseName;

  // Lấy tên category gốc
  String get getCategoryName => categoryName;

  // Lấy id
  int get getId => id;
}