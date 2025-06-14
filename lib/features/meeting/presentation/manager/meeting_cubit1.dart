// meeting_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:sbm_v18/features/meeting/data/data_source/join_meeting_data_source.dart';

import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state1.dart';
import 'meeting_state.dart';

class MeetingCubit1 extends Cubit<MeetingState1> {
  final MeetingRemoteDataSource1 remoteDataSource=MeetingRemoteDataSource1();

  MeetingCubit1() : super(MeetingState1());

  Future<void> requestToJoin(String roomId) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, failure: null));

    final result = await remoteDataSource.requestToJoin(roomId: roomId);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }

  void resetState() {
    emit(const MeetingState1());
  }
}
