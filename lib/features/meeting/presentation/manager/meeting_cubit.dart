import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/data/data_source/meeting_remote_data_source.dart';
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
}
