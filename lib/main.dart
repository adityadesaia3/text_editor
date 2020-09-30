import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Future<PermissionStatus> permissionStatus =
    //     SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    // permissionStatus.then((value) {
    //   print(value.toString());
    // });
    return MaterialApp(
      home: MyTextEditor(),
    );
  }
}

class MyTextEditor extends StatefulWidget {
  @override
  _MyTextEditorState createState() => _MyTextEditorState();
}

class _MyTextEditorState extends State<MyTextEditor> {
  final _textEditingControllerFileName = TextEditingController();
  final _textEditingControllerCode = TextEditingController();

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/counter.txt');
  // }
  _readFile() async {
    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['py', 'c', 'cpp', 'java', 'txt', 'cs', 'dart', 'php'],
    );

    File file = File(filePickerResult.files.first.path);

    _textEditingControllerFileName.text = file.path.split('/').last;

    file.readAsString().then((value) {
      _textEditingControllerCode.text = value.toString();
    });
  }

  _write(String fileName, String code) async {
    // StorageDirectory storageDirectory = StorageDirectory.downloads;
    final Directory directory = await getExternalStorageDirectory();
    try {
      final file = File("${directory.path}/$fileName");
      file.writeAsString(code, mode: FileMode.writeOnly, flush: true);
      _fileSuccessfullySavedAlertDialog(file);
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<void> _fileSuccessfullySavedAlertDialog(File file) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text("Saved!"),
          content: Text("File is successfully saved!\n"
              "Location: ${file.path}"),
          actions: <Widget>[
            FlatButton(
              child: Text("Alright"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _helpAlertDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text("Supported Extensions!"),
          content: Text("['py', 'c', 'cpp', 'java',"
              " 'txt', 'cs', 'dart', 'php']"),
          actions: <Widget>[
            FlatButton(
              child: Text("Alright"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _newFileAlertDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text("New File!"),
          content: Text("Do you want to create a new file?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _textEditingControllerFileName.text = "";
                _textEditingControllerCode.text = "";
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String fileName;
  String code;

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Editor"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("New"),
              onTap: () {
                _newFileAlertDialog();
              },
            ),
            ListTile(
              onTap: () {
                _readFile();
              },
              title: Text("Open"),
            ),
            ListTile(
              title: Text("Save"),
              onTap: () {
                fileName = _textEditingControllerFileName.text.trimRight();
                code = _textEditingControllerCode.text;
                _write(fileName, code);
              },
            ),
            ListTile(
              title: Text("Help"),
              onTap: () {
                _helpAlertDialog();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingControllerFileName,
              decoration:
                  InputDecoration(labelText: "File Name with extension"),
            ),
            TextField(
              controller: _textEditingControllerCode,
              decoration: InputDecoration(labelText: "Write your code here!"),
              maxLines: 20,
            ),
          ],
        ),
      ),
    );
  }
}
