import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherTestPage extends StatefulWidget {
  @override
  _PusherTestPageState createState() => _PusherTestPageState();
}

class _PusherTestPageState extends State<PusherTestPage> {
  final String apiKey = '380d95303fac6cdc3cb0'; // أدخل مفتاحك هنا
  final String cluster = 'us2';        // مثلاً: 'eu'

  late PusherChannelsFlutter pusher;
  String connectionStatus = 'Not connected';
  List<String> receivedEvents = [];

  @override
  void initState() {
    super.initState();
    initPusher();
  }

  Future<void> initPusher() async {
    pusher = PusherChannelsFlutter();

    try {
      await pusher.init(
        apiKey: apiKey,
        cluster: cluster,

        // ✔️ التوقيع الصحيح: وسيطان (الحالي، السابق)
        onConnectionStateChange: (dynamic currentState, dynamic previousState) {
          print("🔌 Connection status: $currentState (prev: $previousState)");
          setState(() => connectionStatus = currentState.toString());
        },

        // ✔️ التوقيع الصحيح: (message, code, exception)
        onError: (String message, int? code, dynamic exception) {
          print("❌ Error: $message (code: $code) → $exception");
          setState(() => connectionStatus = 'Error: $message');
        },

        // ✔️ التوقيع الصحيح: (message, dynamic e)
        onSubscriptionError: (String message, dynamic e) {
          print("⚠️ Subscription error: $message → $e");
        },

        // ✔️ التوقيع الصحيح: (event, reason)
        onDecryptionFailure: (String event, String reason) {
          print("🔒 Decryption failure: $event – $reason");
        },

        // ✔️ التوقيع الصحيح: (channelName, data)
        onSubscriptionSucceeded: (String channelName, dynamic data) {
          print("✅ Subscribed to $channelName");
        },

        // ✔️ استقبال الأحداث
        onEvent: (event) {
          print("📥 Event: ${event.eventName} – ${event.data}");
          setState(() => receivedEvents.add(
            '${event.eventName}: ${event.data}',
          ));
        },
      );

      await pusher.subscribe(channelName: 'meeting.213');
      await pusher.connect();
    } catch (e) {
      print("⚠️ Exception during init: $e");
      setState(() => connectionStatus = 'Exception: $e');
    }
  }

  @override
  void dispose() {
    pusher.unsubscribe(channelName: 'meeting.213');
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pusher Connection Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('🔑 API Key: $apiKey'),
            Text('📡 Cluster: $cluster'),
            SizedBox(height: 12),
            Text('📶 Connection Status: $connectionStatus',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Text('📥 Received Events:', style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: receivedEvents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(receivedEvents[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}