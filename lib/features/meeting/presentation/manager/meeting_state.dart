import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_model.dart';

class MeetingState {
  List<MeetingModel> meetings;

  final Failure? failure;

  final MeetingsIsLoading isLoading;
  final MeetingsIsSuccess isSuccess;
  final MeetingsIsFailure isFailure;

  MeetingState({
    required this.meetings,

    this.failure,

    this.isLoading = MeetingsIsLoading.none,
    this.isSuccess = MeetingsIsSuccess.none,
    this.isFailure = MeetingsIsFailure.none,
  });

  MeetingState copyWith({
    List<MeetingModel>? meetings,

    Failure? failure,

    MeetingsIsLoading? isLoading,
    MeetingsIsSuccess? isSuccess,
    MeetingsIsFailure? isFailure,
  }) {
    return MeetingState(
      meetings: meetings ?? this.meetings,

      failure: failure,

      isLoading: isLoading ?? MeetingsIsLoading.none,
      isSuccess: isSuccess ?? MeetingsIsSuccess.none,
      isFailure: isFailure ?? MeetingsIsFailure.none,
    );
  }
}

enum MeetingsIsLoading {
  none,
  meetings,
  deleteNote,
  addEvent,
  updateEvent,
  searchEvent,
  statistics,
}

enum MeetingsIsSuccess { addEvent, updateEvent, none, deleteEvent, statistics }

enum MeetingsIsFailure { addEvent, updateEvent, none, deleteEvent, statistics }
