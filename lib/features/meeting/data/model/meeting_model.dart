class MeetingModel {
  int id;
  int askToJoin;
  int creatorId;
  String title;
  DateTime startTime;
  int duration;
  String roomId;
  CreatorModel creator;
  List<ParticipantModel> participants;
  List<MediaModel> media;

  MeetingModel({
    required this.id,
    required this.askToJoin,
    required this.creatorId,
    required this.title,
    required this.startTime,
    required this.duration,
    required this.roomId,
    required this.creator,
    required this.participants,
    required this.media,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
    id: json["id"],
    askToJoin: json["ask_to_join"],
    creatorId: json["creator_id"],
    title: json["title"],
    startTime: DateTime.parse(json["start_time"]),
    duration: json["duration"],
    roomId: json["room_id"],
    creator: CreatorModel.fromJson(json["creator"]),
    participants: List<ParticipantModel>.from(
      json["participants"].map((x) => ParticipantModel.fromJson(x)),
    ),
    media: List<MediaModel>.from(
      json["media"].map((x) => MediaModel.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ask_to_join": askToJoin,
    "creator_id": creatorId,
    "title": title,
    "start_time": startTime.toIso8601String(),
    "duration": duration,
    "room_id": roomId,
    "creator": creator.toJson(),
    "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
    "media": List<dynamic>.from(media.map((x) => x.toJson())),
  };
}

class CreatorModel {
  int id;
  String firstName;
  String lastName;
  DateTime birthday;
  String gender;
  String address;
  String phoneNumber;
  String email;

  CreatorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.phoneNumber,
    required this.email,
  });

  factory CreatorModel.fromJson(Map<String, dynamic> json) => CreatorModel(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthday: DateTime.parse(json["birthday"]),
    gender: json["gender"],
    address: json["address"],
    phoneNumber: json["phone_number"],
    email: json["email"],
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
  };
}

class MediaModel {
  int id;
  String url;

  MediaModel({required this.id, required this.url});

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      MediaModel(id: json["id"], url: json["url"]);

  Map<String, dynamic> toJson() => {"id": id, "url": url};
}

class ParticipantModel {
  int id;
  int meetingId;
  int userId;
  DateTime joinedAt;

  ParticipantModel({
    required this.id,
    required this.meetingId,
    required this.userId,
    required this.joinedAt,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        id: json["id"],
        meetingId: json["meeting_id"],
        userId: json["user_id"],
        joinedAt: DateTime.parse(json["joined_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meeting_id": meetingId,
    "user_id": userId,
    "joined_at": joinedAt.toIso8601String(),
  };
}
