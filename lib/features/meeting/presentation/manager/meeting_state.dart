import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';

class MeetingState {
  final List<MeetingInformationModel> meetings;
  final List<MeetingInformationModel> allMeetings;
  final List<MeetingInformationModel> allMeetingsByDate;
  final MeetingInformationModel? meet;
  final String? joinRequestStatus;
  final String? joinResponseStatus;
  final String? inviteStatusMessage;
  final String? transcribedText;
  final String? summaryText;
  final List<String>? transcriptTexts;

  final Failure? failure;

  final MeetingsIsLoading isLoading;
  final MeetingsIsSuccess isSuccess;
  final MeetingsIsFailure isFailure;

  final String? recordingUrl; // ✅ New field

  MeetingState({
    this.transcriptTexts,

    this.summaryText,
    this.transcribedText,
    this.inviteStatusMessage,
    this.joinRequestStatus,
    this.joinResponseStatus,
    required this.allMeetings,
    required this.meetings,
    required this.allMeetingsByDate,
    this.failure,

    this.meet,
    this.isLoading = MeetingsIsLoading.none,
    this.isSuccess = MeetingsIsSuccess.none,
    this.isFailure = MeetingsIsFailure.none,
    this.recordingUrl, // ✅ include in constructor
  });

  MeetingState copyWith({
    List<MeetingInformationModel>? meetings,
    List<MeetingInformationModel>? allMeetings,
    List<MeetingInformationModel>? allMeetingsByDate,
    final String? summaryText,
    Failure? failure,
    final List<String>? transcriptTexts,
    final String? inviteStatusMessage,
    String? joinRequestStatus,
    String? joinResponseStatus,
    final String? transcribedText,

    MeetingInformationModel? meet,
    MeetingsIsLoading? isLoading,
    MeetingsIsSuccess? isSuccess,
    MeetingsIsFailure? isFailure,
    String? recordingUrl, // ✅ New in copyWith
  }) {
    return MeetingState(
      allMeetings: allMeetings ?? this.allMeetings,
      meetings: meetings ?? this.meetings,
      failure: failure,
      allMeetingsByDate: allMeetingsByDate ?? [],
      meet: meet,
      transcriptTexts: transcriptTexts,
      summaryText: summaryText,
      transcribedText: transcribedText,
      inviteStatusMessage: inviteStatusMessage,
      joinRequestStatus: joinRequestStatus,
      joinResponseStatus: joinResponseStatus,
      isLoading: isLoading ?? MeetingsIsLoading.none,
      isSuccess: isSuccess ?? MeetingsIsSuccess.none,
      isFailure: isFailure ?? MeetingsIsFailure.none,
      recordingUrl: recordingUrl ?? this.recordingUrl, // ✅ Set value
    );
  }
}

enum MeetingsIsLoading {
  askToJoin,
  none,
  meetings,
  addMeet,
  uploadRecording,
  getMeetingsByDate,
  respondToCreatorInvitation,
  inviteByCreator,

  transcribeRecording,
  summarizeMeeting,
  voiceSeparation,
}

enum MeetingsIsSuccess {
  askToJoin,
  addMeet,
  none,
  uploadRecording,
  getMeetingsByDate,
  respondToCreatorInvitation,
  inviteByCreator,
  transcribeRecording,
  summarizeMeeting,
  voiceSeparation,
}

enum MeetingsIsFailure {
  askToJoin,
  addMeet,
  none,
  uploadRecording,
  getMeetingsByDate,
  respondToCreatorInvitation,
  inviteByCreator,
  transcribeRecording,
  summarizeMeeting,
  voiceSeparation,
}
