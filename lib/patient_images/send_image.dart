import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ntreatment/Entry/home_page.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color(0xff8DC34D),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff8DC34D), Color(0xffffffff)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.8, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            "Herb-N-Wellness",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                });
              },
              icon: Icon(Icons.logout),
            )
          ],
          centerTitle: true,
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: DropdownButton(
                      hint: const Text('LOAD PATH FROM'),
                      value: _pickingType,
                      items: <DropdownMenuItem>[
                        DropdownMenuItem(
                          child: const Text('FROM AUDIO'),
                          value: FileType.audio,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM IMAGE'),
                          value: FileType.image,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM VIDEO'),
                          value: FileType.video,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM MEDIA'),
                          value: FileType.media,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM ANY'),
                          value: FileType.any,
                        ),
                        DropdownMenuItem(
                          child: const Text('CUSTOM FORMAT'),
                          value: FileType.custom,
                        ),
                      ],
                      onChanged: (value) => setState(() {
                            _pickingType = value;
                            if (_pickingType != FileType.custom) {
                              _controller.text = _extension = '';
                            }
                          })),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 100.0),
                  child: _pickingType == FileType.custom
                      ? TextFormField(
                          maxLength: 15,
                          autovalidateMode: AutovalidateMode.always,
                          controller: _controller,
                          decoration:
                              InputDecoration(labelText: 'File extension'),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                        )
                      : const SizedBox(),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 400.0),
                  child: SwitchListTile.adaptive(
                    title:
                        Text('Pick multiple files', textAlign: TextAlign.right),
                    onChanged: (bool value) =>
                        setState(() => _multiPick = value),
                    value: _multiPick,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _openFileExplorer(),
                        child: const Text("Open file picker"),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectFolder(),
                        child: const Text("Pick folder"),
                      ),
                      ElevatedButton(
                        onPressed: () => _clearCachedFiles(),
                        child: const Text("Clear temporary files"),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const CircularProgressIndicator(),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: const Text('Directory path'),
                              subtitle: Text(_directoryPath),
                            )
                          : _paths != null
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Scrollbar(
                                      child: ListView.separated(
                                    itemCount:
                                        _paths != null && _paths.isNotEmpty
                                            ? _paths.length
                                            : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final bool isMultiPath =
                                          _paths != null && _paths.isNotEmpty;
                                      final String name = 'File $index: ' +
                                          (isMultiPath
                                              ? _paths
                                                  .map((e) => e.name)
                                                  .toList()[index]
                                              : _fileName ?? '...');
                                      final path = _paths
                                          .map((e) => e.path)
                                          .toList()[index]
                                          .toString();

                                      return ListTile(
                                        title: Text(
                                          name,
                                        ),
                                        subtitle: Text(path),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                  )),
                                )
                              : const SizedBox(),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

/*
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntreatment/Entry/home_page.dart';

class SendImage extends StatefulWidget {
  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8DC34D), Color(0xffffffff)],
              begin: const FractionalOffset(0.0,0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.8, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Herb-N-Wellness",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              });
            },
            icon: Icon(Icons.logout),
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: (){

              },
              child: Text(
                "Take Image From Gallery"
              ),
            ),
            RaisedButton(
              onPressed: (){

              },
              child: Text(
                  "Take Image From Camera"
              ),
            ),
            RaisedButton(
              onPressed: (){

              },
              child: Text(
                  "Back"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
