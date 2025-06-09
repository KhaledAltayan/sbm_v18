import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/data/data_source/meeting_remote_data_source.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_model.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  final MeetingRemoteDataSource remote;

  MeetingCubit({required this.remote})
      : super(MeetingState(meetings: []));

  Future<void> getMeetings() async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.meetings));
    final result = await remote.getMeetings();
    result.fold(
      (failure) => emit(state.copyWith(
        failure: failure,
        isLoading: MeetingsIsLoading.none,
        isFailure: MeetingsIsFailure.none,
      )),
      (meetings) => emit(state.copyWith(
        meetings: meetings,
        isLoading: MeetingsIsLoading.none,
        isSuccess: MeetingsIsSuccess.none,
      )),
    );
  }




  void createMeeting({
    required String title,
    required DateTime startTime,
    required int duration,
    bool askToJoin = false,
  }) async {
    emit(state.copyWith(isLoading: MeetingsIsLoading.meetings));
    final result = await remote.createMeeting(
      title: title,
      startTime: startTime,
      duration: duration,
      askToJoin: askToJoin,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(failure: failure, isFailure: MeetingsIsFailure.addEvent));
      },
      (meeting) {
        final updatedMeetings = List<MeetingModel>.from(state.meetings)..add(meeting);
        emit(state.copyWith(meetings: updatedMeetings, isSuccess: MeetingsIsSuccess.addEvent));
      },
    );
  }
}
