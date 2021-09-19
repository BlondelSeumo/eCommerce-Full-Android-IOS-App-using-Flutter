class UserModel {
  int id;
  String username,
      niceName,
      email,
      url,
      registered,
      displayName,
      firstname,
      lastname,
      nickname,
      description,
      avatar;

  List<String> role;

  UserModel(
      {this.id,
      this.username,
      this.niceName,
      this.email,
      this.url,
      this.registered,
      this.displayName,
      this.firstname,
      this.lastname,
      this.nickname,
      this.description,
      this.avatar,
      this.role});

  Map toJson() => {
        'id': id,
        'username': username,
        'nicename': niceName,
        'email': email,
        'url': url,
        'registered': registered,
        'displayname': displayName,
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname,
        'description': description,
        'avatar': avatar,
        'role': role
      };

  UserModel.fromJson(Map json) {
    id = json['id'] ?? json['ID'];
    username = json['username'];
    nickname = json['nickname'];
    niceName = json['nicename'];
    email = json['email'];
    url = json['url'];
    registered = json['registered'];
    displayName = json['displayname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    description = json['description'];
    avatar = json['avatar'];

    if (json['role'] != null) {
      role = [];
      json['role'].forEach((v) {
        role.add(v);
      });
    }
  }
}
