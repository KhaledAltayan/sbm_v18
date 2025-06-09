class MeetingModel {
  String title;
  DateTime startTime;
  String duration;
  String roomId;
  int creatorId;
  int id;

  MeetingModel({
    required this.title,
    required this.startTime,
    required this.duration,
    required this.roomId,
    required this.creatorId,
    required this.id,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
    title: json["title"],
    startTime: DateTime.parse(json["start_time"]),
    duration: json["duration"],
    roomId: json["room_id"],
    creatorId: json["creator_id"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "start_time": startTime.toIso8601String(),
    "duration": duration,
    "room_id": roomId,
    "creator_id": creatorId,
    "id": id,
  };
}
