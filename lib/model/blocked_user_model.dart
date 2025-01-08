// ignore_for_file: public_member_api_docs, sort_constructors_first
class BlockedUserModel {
  final int? id;
  final String? name;
  final String? img;
  bool isBlocked;

  BlockedUserModel({
    this.id,
    this.name,
    this.img,
    this.isBlocked = false,
  });
}
