import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/timer.dart';

class Record extends StatefulWidget {
  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  IconData _iconData = Icons.mic;
  bool _isRecording = false;
  String _recordLabel = 'Press the button to record';
  Stopwatch _stopwatch = Stopwatch();

  Future<void> _recordButtonPress() async {
    if (await Permission.microphone.request().isGranted) {
      setState(() {
        if (!_isRecording) {
          _recordLabel = 'Recording...';
          _startRecording();
          _stopwatch.start();
          _isRecording = true;
          _iconData = Icons.stop;
        } else {
          _recordLabel = 'Press the button to record';
          _stopwatch.reset();
          _stopRecording();
          _stopwatch.stop();
          _isRecording = false;
          _iconData = Icons.mic;
        }
      });
    } else {
      Fluttertoast.showToast(
          msg: "Audio permission require to work.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    // Start recording
    await AudioRecorder.start(
        path: path.join(directory.path, fileName()),
        audioOutputFormat: AudioOutputFormat.AAC);
  }

  Future<void> _stopRecording() async {
    Recording recording = await AudioRecorder.stop();
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("File Saved Successfully.")));
    print(
        "Path : ${recording.path},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");
  }

  String fileName() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return 'Recording_$formattedDate.mp4';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TimerWatch(
          stopwatch: _stopwatch,
        ),
        Text(
          _recordLabel,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          backgroundColor: Colors.teal[400],
          radius: 30,
          child: IconButton(
            onPressed: _recordButtonPress,
            padding: EdgeInsets.zero,
            icon: Icon(
              _iconData,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
