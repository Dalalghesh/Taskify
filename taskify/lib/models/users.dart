class SelectedUser{
  static UserModel? user;
}


class UserModel {
  String docId;
  String email;
  List<dynamic> categories;


  UserModel({
    required this.email,
    required this.docId,
    required this.categories,
});
}