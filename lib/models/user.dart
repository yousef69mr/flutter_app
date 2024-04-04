class User {
  String id;
  String name;
  String email;
  String? avatar;
  String? gender;
  String studentId;
  int level;
  String role;
  String password;

  User(
      {required this.id,
      required this.name,
      required this.email,
      this.avatar,
      this.gender,
      required this.password,
      required this.studentId,
      required this.role,
      required this.level});

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        email = json["email"],
        avatar = json["avatar"],
        password = json["password"],
        studentId = json["studentId"],
        gender = json["gender"],
        role = json["role"],
        level = json["level"];

  @override
  String toString() {
    return 'User{id: $id, name: $name, role: $role, email: $email, avatar: $avatar, gender: $gender, studentId: $studentId, level: $level}';
  }
}
