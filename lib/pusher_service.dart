// import 'package:flutter/foundation.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';



// class PusherService {
//   PusherService();

//   static final instance = PusherService();
//   static const _key = "962f5eb83d88a7252e0e";
//   static const _cluster = "ap2";

//   late PusherChannelsFlutter pusher;
//   late PusherChannel campusBroadcastChannel;
//   late PusherChannel personalChannel;
//   final Set<String> _subscribedChannels = {};

//   // final _repository = SharedRepository();

//   static Future<PusherService> init() async {
//     instance.pusher = PusherChannelsFlutter.getInstance();

//     await instance.pusher.init(
//       apiKey: _key,
//       cluster: _cluster,
//       onEvent: instance.onEvent,
//       onError: instance.onError,
//       onConnectionStateChange: instance.onConnectionStateChange,
//       onSubscriptionSucceeded: instance.onSubscriptionSucceeded,
//       onSubscriptionError: instance.onSubscriptionError,
//       onDecryptionFailure: instance.onDecryptionFailure,
//       onMemberAdded: instance.onMemberAdded,
//       onMemberRemoved: instance.onMemberRemoved,
//       onAuthorizer: instance.onAuthorizer,
//     );

//     return instance;
//   }

//   Future<bool> subscribeToChannel(
//     String channelName, {
//     Function(dynamic)? onEvent,
//   }) async {
//     if (!_subscribedChannels.contains(channelName)) {
//       await pusher.subscribe(channelName: channelName, onEvent: onEvent);
//       _subscribedChannels.add(channelName);
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> unsubscribeFromChannel(String channelName) async {
//     if (_subscribedChannels.contains(channelName)) {
//       await pusher.unsubscribe(channelName: channelName);
//       _subscribedChannels.remove(channelName);
//       return true;
//     }
//     return false;
//   }

//   void onEvent(PusherEvent event) {
//     if (kDebugMode) debugPrint("onEvent: $event");
//   }

//   void onError(String message, int? code, dynamic error) {
//     if (kDebugMode) {
//       debugPrint("onError: $message code: $code exception: $error");
//     }
//   }

//   void onConnectionStateChange(String currentState, String previousState) {
//     if (kDebugMode) {
//       debugPrint(
//         "onConnectionStateChange: $currentState privateState: $previousState",
//       );
//     }
//   }

//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     if (kDebugMode) {
//       debugPrint("onSubscriptionSucceeded: $channelName data: $data");
//     }
//   }

//   void onSubscriptionError(String message, dynamic error) {
//     if (kDebugMode) {
//       debugPrint("onSubscriptionError: $message exception: $error");
//     }
//   }

//   void onDecryptionFailure(String event, String reason) {
//     if (kDebugMode) debugPrint("onDecryptionFailure: $event reason: $reason");
//   }

//   void onMemberAdded(String channelName, PusherMember member) {
//     if (kDebugMode) debugPrint("onMemberAdded: $channelName member: $member");
//   }

//   void onMemberRemoved(String channelName, PusherMember member) {
//     if (kDebugMode) debugPrint("onMemberRemoved: $channelName member: $member");
//   }

//   dynamic onAuthorizer(
//     String channelName,
//     String socketId,
//     dynamic options,
//   ) async {
//     final result =
//         await _repository
//             .authorizePusher(
//               channelName: channelName,
//               socketId: socketId,
//               options: options,
//             )
//             .run();
//     return result.fold(
//       (failure) async {
//         throw Exception("Pusher Service (onAuthorizer): ${failure.toString()}");
//       },
//       (data) {
//         return data;
//       },
//     );
//   }
// }
