import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final meetingNameController = TextEditingController();
  final jitsiMeet = JitsiMeet();
  void join() {

    var options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: "jitsi_Wh8I2G6ckz",
      configOverrides: {
        "startWithAudioMuted": true,
        "startWithVideoMuted": true,
        "subject" : "JitsiwithFlutter",
        "localSubject" : "localJitsiwithFlutter",
      },
      featureFlags: {
        "unsaferoomwarning.enabled": false,
        "security-options.enabled": false
      },
      userInfo: JitsiMeetUserInfo(
          displayName: "Flutter user",
          email: "user@example.com"
      ),
    );
    jitsiMeet.join(options);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                controller: meetingNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter meeting name',
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: FilledButton(
                onPressed: join,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                ),
                child: const Text("Join")
              ),
            ),
          ],
        ),
      ),
    );
  }
}
