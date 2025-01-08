class FirebaseUserModel {
  final String id;
  final String name;
  final String image;
  final bool online;

  FirebaseUserModel({required this.id, required this.name, required this.image, required this.online});

  factory FirebaseUserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FirebaseUserModel(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      online: data['online'] ?? false,
    );
  }
}