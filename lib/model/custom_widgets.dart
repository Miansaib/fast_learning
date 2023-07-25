import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:Fast_learning/tools/tools.dart';
import 'package:uuid/uuid.dart';
import '../music.dart';

class VoicePlayer extends StatefulWidget {
  VoicePlayer({Key? key}) : super(key: key);

  @override
  _VoicePlayerState createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<VoicePlayer> {
  final AudioPlayer _player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ControlButtonsCustom(_player),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class ImagePath extends StatefulWidget {
  final TextEditingController txtImagePath;
  ImagePath({Key? key, required this.txtImagePath}) : super(key: key);

  @override
  _ImagePathState createState() => _ImagePathState();
}

class _ImagePathState extends State<ImagePath> {
  //TextEditingController txtImagePath = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? currentPath;
  XFile? image;
  @override
  void initState() {
    //image =  _picker.pickImage(source: ImageSource.gallery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: widget.txtImagePath.text.isNotEmpty
              ? InkWell(
                  onTap: () async {
                    image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      String newFilePath =
                          await copyFileToApplicationDirectory(image!.path);
                      widget.txtImagePath.text = newFilePath;
                      setState(() {});
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.file(
                          File(widget.txtImagePath.text),
                          width: Get.size.shortestSide * 0.75,
                          height: Get.size.shortestSide * 0.75,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            color: Colors.white,
                            child: IconButton(
                                onPressed: () {
                                  widget.txtImagePath.clear();
                                  setState(() {});
                                },
                                icon: Icon(Icons.close_rounded,
                                    color: Colors.black)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: Container(
                  width: Get.size.shortestSide * 0.75,
                  height: Get.size.shortestSide * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xfff1f2f6),
                  ),
                  child: InkWell(
                    onTap: () async {
                      image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        String newFilePath =
                            await copyFileToApplicationDirectory(image!.path);
                        widget.txtImagePath.text = newFilePath;
                        setState(() {});
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset('assets/images/gallery-add.png'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Add photo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff8a8a8a),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "You can set a photo for the folder.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 98, 98, 98),
                            fontSize: 12,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ),
        // Expanded(
        //   child: GestureDetector(
        //     child: Container(
        //       //width: double.infinity,
        //       height: 48.0,
        //       decoration: BoxDecoration(color: Colors.red.shade300),
        //       child: Center(
        //         child: Text(
        //           'camera'.tr,
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ),
        //     ),
        //     onTap: () async {
        //       image = await _picker.pickImage(source: ImageSource.camera);
        //       if (image != null) {
        //         String newFilePath =
        //             await copyFileToApplicationDirectory(image!.path);
        //         widget.txtImagePath.text = newFilePath;
        //         setState(() {
        //           print(newFilePath);
        //         });
        //       }
        //     },
        //   ),
        // ),

        // InkWell(
        //   onTap: () async {
        //     // image = await _picker.pickImage(source: ImageSource.camera);
        //     // if (image != null) {
        //     //   setState(() {
        //     //     currentPath = image!.path;
        //     //     widget.txtImagePath.text = currentPath!;
        //     //     print(image!.path.toString());
        //     //   });
        //     // }
        //   },
        //   child: Icon(Icons.camera),
        // ),
        // InkWell(
        //   onTap: () async {
        //     // image = await _picker.pickImage(source: ImageSource.gallery);
        //     // if (image != null) {
        //     //   setState(() {
        //     //     currentPath = image!.path;
        //     //     widget.txtImagePath.text = currentPath!;
        //     //     print(image!.path.toString());
        //     //   });
        //     // }
        //   },
        //   child: Icon(
        //     Icons.image,
        //   ),
        //),
      ],
    );
  }
}

class CaseType extends StatefulWidget {
  final TextEditingController caseTypeController;
  CaseType({Key? key, required this.caseTypeController}) : super(key: key);

  @override
  _CaseTypeState createState() => _CaseTypeState();
}

class _CaseTypeState extends State<CaseType> {
  int currentValue = 0;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (widget.caseTypeController.text.isEmpty) {
        widget.caseTypeController.text = '0';
      } else {
        setState(() {
          currentValue = int.parse(widget.caseTypeController.text);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabeledRadio(
            label: 'question'.tr,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            value: 0,
            groupValue: currentValue,
            onChanged: (int newValue) {
              setState(() {
                currentValue = newValue;
                widget.caseTypeController.text = newValue.toString();
              });
            },
          ),
          LabeledRadio(
            label: 'answer'.tr,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            value: 1,
            groupValue: currentValue,
            onChanged: (int newValue) {
              setState(() {
                currentValue = newValue;
                widget.caseTypeController.text = newValue.toString();
              });
            },
          ),
          LabeledRadio(
            label: 'description'.tr,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            value: 2,
            groupValue: currentValue,
            onChanged: (int newValue) {
              setState(() {
                currentValue = newValue;
                widget.caseTypeController.text = newValue.toString();
              });
            },
          ),
          LabeledRadio(
            label: 'picture'.tr,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            value: 3,
            groupValue: currentValue,
            onChanged: (int newValue) {
              setState(() {
                currentValue = newValue;
                widget.caseTypeController.text = newValue.toString();
              });
            },
          ),
        ],
      ),
    );
  }
}

class UnitTime extends StatefulWidget {
  final TextEditingController unitTimeController;
  UnitTime({Key? key, required this.unitTimeController}) : super(key: key);

  @override
  _UnitTimeState createState() => _UnitTimeState();
}

class _UnitTimeState extends State<UnitTime> {
  int currentValue = 3;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (widget.unitTimeController.text.isEmpty) {
        widget.unitTimeController.text = '3';
      } else {
        setState(() {
          currentValue = int.parse(widget.unitTimeController.text);
        });
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff353535), width: 1),
          borderRadius: BorderRadius.circular(10)),

      // color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: DropdownButton<int>(
          value: currentValue,
          items: <int>[
            1,
            2,
            3,
          ].map((int value) {
            switch (value) {
              case 1:
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    'minutes'.tr,
                  ),
                );

              case 2:
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    'houres'.tr,
                  ),
                );
              case 3:
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('days'.tr),
                );

              default:
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(''),
                );
            }
          }).toList(),
          onChanged: (value) {
            setState(() {
              currentValue = value!;
              widget.unitTimeController.text = value.toString();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build1(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // LabeledRadio(
          //   label: 'ثانیه',
          //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
          //   value: 0,
          //   groupValue: currentValue,
          //   onChanged: (int newValue) {
          //     setState(() {
          //       currentValue = newValue;
          //       widget.unitTimeController.text = newValue.toString();
          //     });
          //   },
          // ),
          LabeledRadio(
            label: 'minutes'.tr,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            value: 1,
            groupValue: currentValue,
            onChanged: (int newValue) {
              setState(() {
                currentValue = newValue;
                widget.unitTimeController.text = newValue.toString();
              });
            },
          ),
          LabeledRadio(
            label: 'houres'.tr,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            value: 2,
            groupValue: currentValue,
            onChanged: (int newValue) {
              setState(() {
                currentValue = newValue;
                widget.unitTimeController.text = newValue.toString();
              });
            },
          ),
          LabeledRadio(
            label: 'days'.tr,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            value: 3,
            groupValue: currentValue,
            onChanged: (int newValue) {
              setState(() {
                currentValue = newValue;
                widget.unitTimeController.text = newValue.toString();
              });
            },
          ),
        ],
      ),
    );
  }
}

class LanguageItem extends StatefulWidget {
  final TextEditingController languageItemController;
  LanguageItem({Key? key, required this.languageItemController})
      : super(key: key);

  @override
  _LanguageItemState createState() => _LanguageItemState();
}

class _LanguageItemState extends State<LanguageItem> {
  int curentValue = 0;
  @override
  void initState() {
    if (widget.languageItemController.text.isNotEmpty) {
      curentValue = int.parse(widget.languageItemController.text);
    } else {
      widget.languageItemController.text = '0';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: DropdownButton<int>(
        value: curentValue,
        items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((int value) {
          switch (value) {
            case 0:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('En-US'),
              );
            case 1:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('En-Uk'),
              );

            case 2:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('French'),
              );
            case 3:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('German'),
              );
            case 4:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Spanish'),
              );
            case 5:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Russian'),
              );
            case 6:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Turkish'),
              );
            case 7:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Arabic'),
              );
            case 8:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Chinese'),
              );
            case 9:
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Japanese'),
              );

            default:
              return DropdownMenuItem<int>(
                value: value,
                child: Text(''),
              );
          }
        }).toList(),
        onChanged: (value) {
          setState(() {
            curentValue = value!;
            widget.languageItemController.text = value.toString();
          });
        },
      ),
    );
  }
}

class VoicePath extends StatefulWidget {
  VoicePath({Key? key}) : super(key: key);

  @override
  _VoicePathState createState() => _VoicePathState();
}

class _VoicePathState extends State<VoicePath> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () async {
          String filePath = '/sdcard/Download/temp1.m4a';
          await Permission.microphone.request();
          await Permission.storage.request();
          await Permission.manageExternalStorage.request();
          Record record = Record();
          bool result = await record.hasPermission();
          Directory dir = Directory(path.dirname(filePath));
          bool fileExist = await dir.exists();
          if (fileExist == false) {
            dir.createSync();
            new File('path/to/sample.txt').create(recursive: true);
          } else {
            print('exist');
          }
          if (await record.hasPermission()) {
            await record.start(
              path: filePath, // required
              encoder: AudioEncoder.AAC, // by default
              bitRate: 128000, // by default
              samplingRate: 44100, // by default
            );
          }
        },
        child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.rectangle, color: Colors.red),
            child: Icon(
              Icons.fiber_manual_record_sharp,
              color: Colors.white,
            )),
      ),
    );
  }
//   void createFileRecursively(String filename) {
//   // Create a new directory, recursively creating non-existent directories.
//   new Directory.fromRawPath((new Path(filename).directoryPath)
//       .createSync(recursive: true);
//   new File(filename).createSync();
// }
}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final int groupValue;
  final int value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<int>(
              groupValue: groupValue,
              value: value,
              onChanged: (int? newValue) {
                onChanged(newValue);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
