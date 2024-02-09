class Post {
  String id;
  String name;
  String img;
  dynamic avatar;
  bool like;
  bool save;
  Post(
      {required this.id,
      required this.name,
      required this.img,
      required this.avatar,
      required this.like,
      required this.save});
}
