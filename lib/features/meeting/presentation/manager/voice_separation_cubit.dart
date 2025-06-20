// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:sbm_v18/features/meeting/data/data_source/voice_separation_remote_data_source.dart';
// // import 'package:sbm_v18/features/meeting/presentation/manager/voice_separation_state.dart';

// // class VoiceSeparationCubit extends Cubit<VoiceSeparationState> {
// //   final VoiceSeparationRemoteDataSource remote =
// //       VoiceSeparationRemoteDataSource();

// //   VoiceSeparationCubit() : super(VoiceSeparationState(voices: []));

//   Future<void> getVoiceSeparation(String meetingId) async {
//     emit(state.copyWith(isLoading: VoiceSeparationIsLoading.voices));

//     final result = await remote.voiceSeparation(meetingId);

//     result.fold(
//       (failure) {
//         emit(
//           state.copyWith(
//             failure: failure,
//             isLoading: VoiceSeparationIsLoading.none,
//             isFailure: VoiceSeparationFailure.voices,
//           ),
//         );
//       },
//       (list) {
//         final transcriptTexts =
//             list.map((e) => "${e.speaker}: ${e.text}").toList();

//         emit(
//           state.copyWith(
//             voices: transcriptTexts,
//             isLoading: MeetingsIsLoading.none,
//             isSuccess: MeetingsIsSuccess.voiceSeparation,
//           ),
//         );
//       },
//     );
//   }
// }
