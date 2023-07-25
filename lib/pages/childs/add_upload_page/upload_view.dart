import 'dart:io';
import 'package:Fast_learning/constants/preference.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'service.dart';

class ImageUpload extends StatelessWidget {
  final List<GlobalKey>? keys;
  ImageUpload(this.keys);
  Service service = Service();
  final _addFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // setState(() {
    //   if (pickedFile != null) {
    //     _image = File(pickedFile.path);
    //   } else {
    //     print('No image selected.');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Images'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Container(
            child: Card(
                child: Container(
                    child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Text('Image Title'),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Title',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                    child:
                        TextButton(onPressed: getImage, child: _buildImage())),
                Container(
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          if (_addFormKey.currentState!.validate()) {
                            _addFormKey.currentState!.save();
                            Map<String, String> body = {
                              'title': _titleController.text
                            };
                            service.addImage(body, _image!.path);
                          }
                        },
                        child: Text('Save'),
                      ),
                      hintWidget(context, keys)
                    ],
                  ),
                ),
              ],
            ))),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (_image == null) {
      return Icon(
        Icons.add,
        color: Colors.grey,
      );
    } else {
      // return Text(_image!.path);
      return Image.file(_image!);
    }
  }
}

Container hintWidget(BuildContext context, List<GlobalKey>? keys) {
  return Container(
      child: IconButton(
    icon: Icon(
      Icons.help_outline_outlined,
      color: Colors.white,
    ),
    onPressed: () {
      // SharedPreferences.getInstance().then((prefs) {
      //   prefs.setBool(Preference.show_hint_traning_page,
      //       !(prefs.getBool(Preference.show_hint_traning_page) ?? true));

      //   // if ((prefs.getBool(Preference.show_hint_traning_page) ?? true)) {}
      // });
      (WidgetsBinding.instance).addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase(keys ?? []),
      );
    },
    // child: Text(musicController.audios_path[
    //     musicController.currentAudioIndex.value]),
  ));
}
