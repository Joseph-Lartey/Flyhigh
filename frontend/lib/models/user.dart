/// Class to model a user
class User {
  int userId;
  String firstName;
  String lastName;
  String username;
  String email;
  String? profileImage;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        userId: json['user_id'], 
        firstName: json['firstname'],
        lastName: json['lastname'],
        username: json['username'],
        email: json['email'],
        profileImage: json['profile_picture_path'], 
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'firstname': firstName,
      'lastname': lastName,
      'username': username,
      'email': email,
      'profile_picture_path': profileImage, 
    };
  }
}
