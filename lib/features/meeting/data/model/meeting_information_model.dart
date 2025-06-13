class MeetingInformationModel {
  int id;
  int askToJoin;
  int creatorId;
  String title;
  DateTime startTime;
  String roomId;

  Creator creator;
  List<Participant> participants;
  List<Media> media;

  MeetingInformationModel({
    required this.id,
    required this.askToJoin,
    required this.creatorId,
    required this.title,
    required this.startTime,
    required this.roomId,

    required this.creator,
    required this.participants,
    required this.media,
  });

  factory MeetingInformationModel.fromJson(Map<String, dynamic> json) =>
      MeetingInformationModel(
        id: json["id"],
        askToJoin: json["ask_to_join"],
        creatorId: json["creator_id"],
        title: json["title"],
        startTime: DateTime.parse(json["start_time"]),
        roomId: json["room_id"],

        creator: Creator.fromJson(json["creator"]),
        participants: List<Participant>.from(
          json["participants"].map((x) => Participant.fromJson(x)),
        ),
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ask_to_join": askToJoin,
    "creator_id": creatorId,
    "title": title,
    "start_time": startTime.toIso8601String(),
    "room_id": roomId,

    "creator": creator.toJson(),
    "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
    "media": List<dynamic>.from(media.map((x) => x.toJson())),
  };
}

class Creator {
  int id;
  String firstName;
  String lastName;
  DateTime birthday;
  String gender;
  String address;
  String phoneNumber;
  String email;

  String media;

  Creator({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.phoneNumber,
    required this.email,

    required this.media,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthday: DateTime.parse(json["birthday"]),
    gender: json["gender"],
    address: json["address"],
    phoneNumber: json["phone_number"],
    email: json["email"],

    media: json["media"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "birthday":
        "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "address": address,
    "phone_number": phoneNumber,
    "email": email,

    "media": media,
  };
}

class Media {
  int id;
  String url;

  Media({required this.id, required this.url});

  factory Media.fromJson(Map<String, dynamic> json) =>
      Media(id: json["id"], url: json["url"]);

  Map<String, dynamic> toJson() => {"id": id, "url": url};
}

class Participant {
  int id;
  int meetingId;
  int userId;
  DateTime joinedAt;

  User user;

  Participant({
    required this.id,
    required this.meetingId,
    required this.userId,
    required this.joinedAt,

    required this.user,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    id: json["id"],
    meetingId: json["meeting_id"],
    userId: json["user_id"],
    joinedAt: DateTime.parse(json["joined_at"]),

    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meeting_id": meetingId,
    "user_id": userId,
    "joined_at": joinedAt.toIso8601String(),

    "user": user.toJson(),
  };
}

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String media;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.media,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    media: json["media"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "media": media,
  };
}
