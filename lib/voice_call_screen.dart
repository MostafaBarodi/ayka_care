import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = '59ee7387057343b7839b04ae7e05ca85';
const String token =
    "007eJxTYOid/nxC9qsAodz2m2erXJSqGeLOeRtXmEwvun3xj9/L1jsKDKaWqanmxhbmBqbmxibGSeYWxpZJBiaJqeapBqbJiRamu1/KZjQEMjL8/JTCwsgAgSA+F0NiZXZifFF+fq4hAwMAgBMjig=="; // For testing only

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  const VideoCallScreen({required this.channelName, super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;
  bool _isJoined = false;
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _isJoined = true);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Call")),
      body: Center(
        child: Stack(
          children: [
            if (!_isJoined)
              const Center(
                child: Text(
                  "Waiting for others to join...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (_isJoined)
              AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            if (_remoteUid != null)
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
