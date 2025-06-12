class UserInformationModel {
  final User user;
  final Image image;
  final String token;
  final FcmToken fcmToken;

  UserInformationModel({
    required this.user,
    required this.image,
    required this.token,
    required this.fcmToken,
  });

  factory UserInformationModel.fromJson(Map<String, dynamic> json) =>
      UserInformationModel(
        user: User.fromJson(json["user"] ?? {}),
        image: Image.fromJson(json["image"] ?? {}),
        token: json["token"] ?? "",
        fcmToken: FcmToken.fromJson(json["fcm_token"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "image": image.toJson(),
    "token": token,
    "fcm_token": fcmToken.toJson(),
  };
}

class FcmToken {
  final String token;

  FcmToken({required this.token});

  factory FcmToken.fromJson(Map<String, dynamic> json) =>
      FcmToken(token: json["token"] ?? "");

  Map<String, dynamic> toJson() => {"token": token};
}

class Image {
  final int id;
  final String image;

  Image({required this.id, required this.image});

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(id: json["id"] ?? -1, image: json["image"] ?? "no_image.png");

  Map<String, dynamic> toJson() => {"id": id, "image": image};
}

class User {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String gender;
  final String address;
  final DateTime birthday;
  final int id;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.address,
    required this.birthday,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["first_name"] ?? "Unknown",
    lastName: json["last_name"] ?? "Unknown",
    phoneNumber: json["phone_number"] ?? "No Phone",
    email: json["email"] ?? "No Email",
    gender: json["gender"] ?? "Not Specified",
    address: json["address"] ?? "No Address",
    birthday:
        json["birthday"] != null
            ? DateTime.tryParse(json["birthday"]) ?? DateTime(1970, 1, 1)
            : DateTime(1970, 1, 1),
    id: json["id"] ?? -1,
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "phone_number": phoneNumber,
    "email": email,
    "gender": gender,
    "address": address,
    "birthday":
        "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "id": id,
  };
}
