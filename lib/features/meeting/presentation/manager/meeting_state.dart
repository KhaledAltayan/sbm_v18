import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';

class MeetingState {
  final List<MeetingInformationModel> meetings;
  final List<MeetingInformationModel> allMeetings;
  final MeetingInformationModel? meet;

  final Failure? failure;

  final MeetingsIsLoading isLoading;
  final MeetingsIsSuccess isSuccess;
  final MeetingsIsFailure isFailure;

  final String? recordingUrl; // ✅ New field

  MeetingState({
    required this.allMeetings,
    required this.meetings,
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
    Failure? failure,
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
      meet: meet,
      isLoading: isLoading ?? MeetingsIsLoading.none,
      isSuccess: isSuccess ?? MeetingsIsSuccess.none,
      isFailure: isFailure ?? MeetingsIsFailure.none,
      recordingUrl: recordingUrl ?? this.recordingUrl, // ✅ Set value
    );
  }
}

enum MeetingsIsLoading { none, meetings, addMeet, uploadRecording }

enum MeetingsIsSuccess { addMeet, none, uploadRecording }

enum MeetingsIsFailure { addMeet, none, uploadRecording }
