class MeetingModel1 {
  String title;
  DateTime startTime;
  DateTime createdAt;
  String duration;
  String roomId;
  int creatorId;
  int id;

  MeetingModel1({
    required this.title,
    required this.startTime,
    required this.duration,
    required this.roomId,
    required this.creatorId,
    required this.id,
    required this.createdAt
  });

  factory MeetingModel1.fromJson(Map<String, dynamic> json) => MeetingModel1(
    title: json["title"],
    startTime: DateTime.parse(json["start_time"]),
    duration: json["duration"],
    roomId: json["room_id"],
    creatorId: json["creator_id"],
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
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
