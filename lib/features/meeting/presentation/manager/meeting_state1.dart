// meeting_state.dart



import 'package:sbm_v18/core/network/failure.dart';

class MeetingState1 {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;

  const MeetingState1({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
  });

  MeetingState1 copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
  }) {
    return MeetingState1(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: failure,
    );
  }
}
