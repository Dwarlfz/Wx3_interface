class UserModel {
  final String id;
  final String name;
  final String email;
  final String squad;
  final String rank;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.squad,
    required this.rank,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      squad: map['squad'] ?? '',
      rank: map['rank'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'squad': squad,
      'rank': rank,
    };
  }
}
