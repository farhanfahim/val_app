// ignore_for_file: public_member_api_docs, sort_constructors_first
class LikesModel {
  final int? id;
  final String? name;
  final String? img;
   bool isFollow;

  LikesModel({
    this.id,
    this.name,
    this.img,
    this.isFollow=false,
  });
}
