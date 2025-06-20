class VoiceSeparationModel {
  String speaker;
  String text;

  VoiceSeparationModel({required this.speaker, required this.text});

  factory VoiceSeparationModel.fromJson(Map<String, dynamic> json) =>
      VoiceSeparationModel(
        speaker: json["speaker"] ?? "No Data",

        text: json["text"] ?? "No Data",
      );

  Map<String, dynamic> toJson() => {"speaker": speaker, "text": text};
}
