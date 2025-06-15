import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/data/data_source/meeting_remote_data_source.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';

import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  final MeetingRemoteDataSource remote = MeetingRemoteDataSource();

  MeetingCubit() : super(MeetingState(meetings: [], allMeetings: []));

  Future<void> getMeetings() async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.meetings));
    final result = await remote.getMeetings();
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          isLoading: MeetingsIsLoading.none,
          isFailure: MeetingsIsFailure.none,
        ),
      ),
      (meetings) => emit(
        state.copyWith(
          allMeetings: meetings,
          meetings: meetings,
          isLoading: MeetingsIsLoading.none,
          isSuccess: MeetingsIsSuccess.none,
        ),
      ),
    );
  }

  void searchMeetingsByName(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(meetings: state.allMeetings));
      return;
    }

    final filtered =
        state.allMeetings.where((meeting) {
          return meeting.title.toLowerCase().contains(query.toLowerCase());
        }).toList();

    emit(state.copyWith(meetings: filtered));
  }

  void createMeeting({
    required String title,
    required DateTime startTime,

    bool askToJoin = false,
  }) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.addMeet));
    final result = await remote.createMeeting(
      title: title,
      startTime: startTime,

      askToJoin: askToJoin,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            failure: failure,
            isFailure: MeetingsIsFailure.addMeet,
          ),
        );
      },
      (meeting) {
        final updatedMeetings = List<MeetingInformationModel>.from(
          state.meetings,
        )..add(meeting);
        emit(
          state.copyWith(
            meet: meeting,
            meetings: updatedMeetings,
            isSuccess: MeetingsIsSuccess.addMeet,
          ),
        );
      },
    );
  }

  void uploadRecording({
    required int meetingId,
    required String filePath,
  }) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.uploadRecording));
    final result = await remote.uploadRecording(
      meetingId: meetingId,
      filePath: filePath,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: MeetingsIsLoading.none,
          isFailure: MeetingsIsFailure.uploadRecording,
          failure: failure,
        ),
      ),
      (url) => emit(
        state.copyWith(
          isLoading: MeetingsIsLoading.none,
          isSuccess: MeetingsIsSuccess.uploadRecording,
          recordingUrl: url,
        ),
      ),
    );
  }
}
