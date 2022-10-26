class SelectedUser {
  static UserInfoModel? user;
}

class UserInfoModel {
  String docId;
  String email;
  String fullname;
  String photo;
  List<dynamic> categories;

  UserInfoModel({
    required this.email,
    required this.photo,
    required this.fullname,
    required this.docId,
    required this.categories,
  });
}
