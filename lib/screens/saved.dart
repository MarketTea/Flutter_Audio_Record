import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:audioplayers/audio_cache.dart';

import 'audio.dart';

class Saved extends StatefulWidget {
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  AudioCache audioCache = new AudioCache();

  List<dynamic> file = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    _listOfFiles();
  }

  // Make New Function
  void _listOfFiles() async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    print("Directory--------------- $directory");
    setState(() {
      file = io.Directory("$directory/")
          .listSync()
          .where((element) => element.path.split(".").last == "mp4")
          .toList();
    });
    print("Directory Path is $file");
  }

  Future<File> get _localFile async {
    final abc = _listOfFiles;
    print('ABC------------------------ $abc');
    return File('$abc');
  }

  Future<void> deleteFile() async {
    try {
      final file = await _localFile;
      await file.delete();
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  Future<void> deleteFiles(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: file.length,
        itemBuilder: (BuildContext context, int index) {
          final item = file[index].toString();
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                file.removeAt(index);
                //deleteFile();
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$item dismissed')));
            },
            background: Container(
              color: Colors.red,
              margin: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              elevation: 2.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Audio(
                          file: file[index],
                        ),
                      ));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.play_circle_filled,
                    color: Colors.blue[800],
                    size: 40.0,
                  ),
                  title: Text(file[index].path.split('/').last),
                  // subtitle: Text(file[index].toString()),
                ),
              ),
            ),
          );
        });
  }
}
