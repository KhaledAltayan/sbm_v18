import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/data/data_source/meeting_remote_data_source.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';

import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  final MeetingRemoteDataSource remote = MeetingRemoteDataSource();

  MeetingCubit()
    : super(MeetingState(meetings: [], allMeetings: [], allMeetingsByDate: []));

  void getMeetingsByDate(String date) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.getMeetingsByDate));
    final result = await remote.searchMeetingsByDate(date);
    result.fold(
      (failure) {
        emit(state.copyWith(failure: failure));
      },
      (meetings) {
        emit(state.copyWith(allMeetingsByDate: meetings));
      },
    );
  }

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

  void askToJoin(String roomId) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.askToJoin));
    final result = await remote.askToJoin(roomId: roomId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isFailure: MeetingsIsFailure.askToJoin,
            failure: failure,
          ),
        );
      },
      (status) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isSuccess: MeetingsIsSuccess.askToJoin,
            joinRequestStatus: status,
          ),
        );
      },
    );
  }

  void respondToCreatorInvitation({
    required int invitationId,
    required String action,
  }) async {
    emit(
      state.copyWith(isLoading: MeetingsIsLoading.respondToCreatorInvitation),
    );

    final result = await remote.respondToCreatorInvitation(
      invitationId: invitationId,
      action: action,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isFailure: MeetingsIsFailure.respondToCreatorInvitation,
            failure: failure,
          ),
        );
      },
      (status) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isSuccess: MeetingsIsSuccess.respondToCreatorInvitation,
            joinResponseStatus: status,
          ),
        );
      },
    );
  }

  void inviteUserByCreator({
    required int userId,
    required int meetingId,
  }) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.inviteByCreator));

    final result = await remote.inviteUserByCreator(
      userId: userId,
      meetingId: meetingId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isFailure: MeetingsIsFailure.inviteByCreator,
            failure: failure,
          ),
        );
      },
      (message) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isSuccess: MeetingsIsSuccess.inviteByCreator,
            inviteStatusMessage: message, // Add this to your state model
          ),
        );
      },
    );
  }

  void transcribeMeeting({required int meetingId}) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.transcribeRecording));

    final result = await remote.transcribeMeeting(meetingId: meetingId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isFailure: MeetingsIsFailure.transcribeRecording,
            failure: failure,
          ),
        );
      },
      (transcriptionText) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isSuccess: MeetingsIsSuccess.transcribeRecording,
            transcribedText: transcriptionText,
          ),
        );
      },
    );
  }

  void summarizeMeeting({
    required String query,
    required String document,
  }) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.summarizeMeeting));

    final result = await remote.summarizeMeeting(
      query: query,
      document: document,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isFailure: MeetingsIsFailure.summarizeMeeting,
            failure: failure,
          ),
        );
      },
      (summaryText) {
        emit(
          state.copyWith(
            isLoading: MeetingsIsLoading.none,
            isSuccess: MeetingsIsSuccess.summarizeMeeting,
            summaryText: summaryText,
          ),
        );
      },
    );
  }

  // void voiceSeparation({required int meetingId}) async {
  //   emit(state.copyWith(isLoading: MeetingsIsLoading.voiceSeparation));

  //   final result = await remote.voiceSeparation(meetingId: meetingId);

  //   result.fold(
  //     (failure) {
  //       emit(
  //         state.copyWith(
  //           isLoading: MeetingsIsLoading.none,
  //           isFailure: MeetingsIsFailure.voiceSeparation,
  //           failure: failure,
  //         ),
  //       );
  //     },
  //     (transcriptList) {
  //       emit(
  //         state.copyWith(
  //           isLoading: MeetingsIsLoading.none,
  //           isSuccess: MeetingsIsSuccess.voiceSeparation,
  //           transcriptTexts: transcriptList,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> getVoiceSeparation(int meetingId) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.voiceSeparation));

    final result = await remote.voiceSeparation(meetingId: meetingId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            failure: failure,
            isLoading: MeetingsIsLoading.none,
            isFailure: MeetingsIsFailure.voiceSeparation,
          ),
        );
      },
      (list) {
        final transcriptTexts =
            list.map((e) => "${e.speaker}: ${e.text}").toList();

        emit(
          state.copyWith(
            voiceSeparation: transcriptTexts,
            isLoading: MeetingsIsLoading.none,
            isSuccess: MeetingsIsSuccess.voiceSeparation,
          ),
        );
      },
    );
  }
}
