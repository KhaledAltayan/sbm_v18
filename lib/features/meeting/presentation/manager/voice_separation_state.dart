import 'package:sbm_v18/core/network/failure.dart';

import 'package:sbm_v18/features/meeting/data/model/voice_separation_model.dart';

class VoiceSeparationState {
  final List<VoiceSeparationModel> voices;

  final Failure? failure;

  final VoiceSeparationIsLoading isLoading;
  final VoiceSeparationIsSuccess isSuccess;
  final VoiceSeparationFailure isFailure;

  VoiceSeparationState({
    required this.voices,

    this.failure,

    this.isLoading = VoiceSeparationIsLoading.none,
    this.isSuccess = VoiceSeparationIsSuccess.none,
    this.isFailure = VoiceSeparationFailure.none,
  });

  VoiceSeparationState copyWith({
    List<VoiceSeparationModel>? voices,

    Failure? failure,

    VoiceSeparationIsLoading? isLoading,
    VoiceSeparationIsSuccess? isSuccess,
    VoiceSeparationFailure? isFailure,
  }) {
    return VoiceSeparationState(
      voices: voices ?? this.voices,
      failure: failure,

      isLoading: isLoading ?? VoiceSeparationIsLoading.none,
      isSuccess: isSuccess ?? VoiceSeparationIsSuccess.none,
      isFailure: isFailure ?? VoiceSeparationFailure.none,
    );
  }
}

enum VoiceSeparationIsLoading { none, voices }

enum VoiceSeparationIsSuccess { none, voices }

enum VoiceSeparationFailure { none, voices }
