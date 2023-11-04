class User {
  var name = '';
  var phone = '';
  var email = '';
  var address = '';
  var avatar = '';
  var nationality = '';
  User();
  User.fromMap(Map<String, dynamic> data) {
    name = data['name'] != null ? data['name'] : '';
    nationality = data['nationality'] != null ? data['nationality'] : '';
    phone = data['phone'] != null ? data['phone'] : '';
    email = data['email'] != null ? data['email'] : '';
    address = data['address'] != null ? data['address'] : '';
    avatar = data['avatar'] != null ? data['avatar'] : '';
  }
}
