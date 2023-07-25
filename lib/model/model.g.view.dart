// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

part of 'model.dart';

class RootGroupAdd extends StatefulWidget {
  RootGroupAdd(this._rootgroup);
  final dynamic _rootgroup;
  @override
  State<StatefulWidget> createState() =>
      RootGroupAddState(_rootgroup as RootGroup);
}

class RootGroupAddState extends State {
  RootGroupAddState(this.rootgroup);
  RootGroup rootgroup;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtImagePath = TextEditingController();

  @override
  void initState() {
    txtTitle.text = rootgroup.title == null ? '' : rootgroup.title.toString();
    txtImagePath.text =
        rootgroup.imagePath == null ? '' : rootgroup.imagePath.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            buildRowTitle(),
            SizedBox(
              height: 10,
            ),
            // buildRowImagePath(),
            ImagePath(txtImagePath: txtImagePath),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8.0),
              child: SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff27187E), //background color of button
                      // side: BorderSide(
                      //     width: 3,
                      //     color: Colors.brown), //border width and color
                      elevation: 3, //elevation of button
                      shape: RoundedRectangleBorder(
                          //to set border radius to button
                          borderRadius: BorderRadius.circular(15)),
                      padding:
                          EdgeInsets.all(15) //content padding inside button
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.save),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Text(
                        (rootgroup.id == null) ? 'Make it!'.tr : "Save Edits",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      save();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
          title: (rootgroup.id == null)
              ? Text(
                  'add_group'.tr,
                  style: Get.theme.textTheme.headline1!
                      .copyWith(color: Colors.white),
                )
              : Text(
                  rootgroup.title ?? 'add_group'.tr,
                  style: Get.theme.textTheme.headline1!
                      .copyWith(color: Colors.white),
                )),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    buildRowTitle(),
                    SizedBox(
                      height: 10,
                    ),
                    // buildRowImagePath(),
                    ImagePath(txtImagePath: txtImagePath),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors
                                .blue.shade300, //background color of button
                            // side: BorderSide(
                            //     width: 3,
                            //     color: Colors.brown), //border width and color
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(0)),
                            padding: EdgeInsets.all(
                                15) //content padding inside button
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(
                              width: 10,
                            ),
                            Text('save'.tr),
                          ],
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            save();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowTitle() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'required_error'.tr;
        }
        return null;
      },
      controller: txtTitle,
      decoration: InputDecoration(labelText: 'title'.tr),
    );
  }

  Widget buildRowImagePath() {
    return TextFormField(
      controller: txtImagePath,
      decoration: InputDecoration(labelText: 'ImagePath'),
    );
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    if (rootgroup.id == null) {
      final all = await RootGroup().select().orderBy('serverId').toList();
      for (var i = 0; i < all.length; i++) {
        all[i].serverId = i + 1;
        await all[i].save();
      }
      rootgroup.serverId = 0;
    }
    rootgroup
      ..title = txtTitle.text
      ..imagePath = txtImagePath.text;
    await rootgroup.save();
    if (rootgroup.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(rootgroup.saveResult.toString(),
          title: 'save RootGroup Failed!', callBack: () {});
    }
  }
}

class SubGroupAdd extends StatefulWidget {
  SubGroupAdd(this._subgroup, {this.showAppBar = true});
  final bool showAppBar;
  final dynamic _subgroup;
  @override
  State<StatefulWidget> createState() =>
      SubGroupAddState(_subgroup as SubGroup, showAppBar);
}

class SubGroupAddState extends State {
  SubGroupAddState(this.subgroup, this.showAppBar);
  bool showAppBar;
  SubGroup subgroup;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtRatio = TextEditingController();
  final TextEditingController txtCaseType = TextEditingController();
  final TextEditingController txtCountTime = TextEditingController();
  final TextEditingController txtUnitTime = TextEditingController();
  final TextEditingController txtBoxCount = TextEditingController();
  final TextEditingController txtLanguageItemOne = TextEditingController();
  final TextEditingController txtLanguageItemTwo = TextEditingController();
  final TextEditingController txtLanguageItemThree = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  //final TextEditingController txtServerId = TextEditingController();
  final TextEditingController txtOrderIndex = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForRootGroupId =
      <DropdownMenuItem<int>>[];
  int? _selectedRootGroupId;

  final TextEditingController txtImagePath = TextEditingController();

  @override
  void initState() {
    txtOrderIndex.text =
        subgroup.orderIndex == null ? '' : subgroup.orderIndex.toString();
    txtTitle.text = subgroup.title == null ? '' : subgroup.title.toString();
    txtRatio.text = subgroup.ratio == null ? '' : subgroup.ratio.toString();

    txtPassword.text =
        subgroup.password == null ? '' : subgroup.password.toString();
    txtCaseType.text =
        subgroup.caseType == null ? '' : subgroup.caseType.toString();
    txtCountTime.text =
        subgroup.countTime == null ? '' : subgroup.countTime.toString();
    txtUnitTime.text =
        subgroup.unitTime == null ? '' : subgroup.unitTime.toString();
    txtBoxCount.text =
        subgroup.boxCount == null ? '' : subgroup.boxCount.toString();
    txtLanguageItemOne.text = subgroup.languageItemOne == null
        ? ''
        : subgroup.languageItemOne.toString();
    txtLanguageItemTwo.text = subgroup.languageItemTwo == null
        ? ''
        : subgroup.languageItemTwo.toString();
    txtLanguageItemThree.text = subgroup.languageItemThree == null
        ? ''
        : subgroup.languageItemThree.toString();
    txtImagePath.text =
        subgroup.imagePath == null ? '' : subgroup.imagePath.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForRootGroupId() async {
      final dropdownMenuItems =
          await RootGroup().select().toDropDownMenuInt('title');
      setState(() {
        _dropdownMenuItemsForRootGroupId = dropdownMenuItems;
        _selectedRootGroupId = subgroup.rootGroupId;
      });
    }

    if (_dropdownMenuItemsForRootGroupId.isEmpty) {
      buildDropDownMenuForRootGroupId();
    }
    void onChangeDropdownItemForRootGroupId(int? selectedRootGroupId) {
      setState(() {
        _selectedRootGroupId = selectedRootGroupId;
      });
    }

    return Scaffold(
      appBar: AppBar(
          title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: (subgroup.id == null)
            ? Text(
                'add_book'.tr,
                style: Get.theme.textTheme.headline1!
                    .copyWith(color: Colors.white),
              )
            : Text(
                subgroup.title ?? 'add_book'.tr,
                style: Get.theme.textTheme.headline1!
                    .copyWith(color: Colors.white),
              ),
      )),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildRowTitle(),
                    SizedBox(height: 15),
                    //buildRowImagePath(),
                    ImagePath(txtImagePath: txtImagePath),

                    // SizedBox(
                    //   height: 10,
                    // ),
                    //  buildRowCaseType(),

                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //buildRowLanguageItemOne(),
                    Row(
                      children: [
                        Text(
                          "Set Language",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: "Poppins",
                              color: Color(0xff353535)),
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(Icons.info_outline_rounded),
                          onPressed: () => hintDialog('Set Language',
                              'You can set language for each section of your flashcards. By choosing these language TTS(text to speach) module of your phone can generate voice for your flashcards'),
                          color: Color(0xff353535),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('lang_question'.tr),
                        SizedBox(
                          width: 10,
                        ),
                        LanguageItem(
                          languageItemController: txtLanguageItemOne,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // buildRowLanguageItemTwo(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('lang_answer'.tr),
                          SizedBox(
                            width: 10,
                          ),
                          LanguageItem(
                            languageItemController: txtLanguageItemTwo,
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    //buildRowLanguageItemThree(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('lang_description'.tr),
                          SizedBox(
                            width: 10,
                          ),
                          LanguageItem(
                            languageItemController: txtLanguageItemThree,
                          ),
                        ]),

                    SizedBox(height: 10),

                    // (subgroup.id == null) ? buildRowPassword() : Container(),
                    (subgroup.password == null ||
                            (subgroup.password != null &&
                                subgroup.passwordConfirmed == true))
                        ? buildRowPassword()
                        : Container(),

                    SizedBox(height: 10),
                    buildRowRootGroupId(onChangeDropdownItemForRootGroupId),
                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    // SizedBox(height: 10),
                    //  buildRowDateCreated(),
                    //  buildRowExamDone(),
                    // buildRowBoxNumber(),
                    //  buildRowBoxVisibleDate(),

                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff8A8A8A), width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        title: Text(
                          "More Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                          ),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: buildRowCountTime()),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // buildRowUnitTime(),
                                    UnitTime(
                                      unitTimeController: txtUnitTime,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(height: 10),
                                buildRowBoxCount(),
                                SizedBox(height: 10),
                                buildRowRatio(),
                                SizedBox(height: 10),
                                buildRowOrderIndex(),
                                SizedBox(height: 10),
                                CaseType(caseTypeController: txtCaseType),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:
                                Color(0xff27187E), //background color of button
                            // side: BorderSide(
                            //     width: 3,
                            //     color: Colors.brown), //border width and color
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(
                                15) //content padding inside button
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.save),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Text(
                              (subgroup.id == null)
                                  ? 'Make it!'.tr
                                  : "Save Edits",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            save();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowOrderIndex() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || int.tryParse(value) == null) {
            return 'valid_number_error'.tr;
          }

          return null;
        },
        controller: txtOrderIndex,
        decoration: InputDecoration(
            labelText: "OrderIndex".tr,
            // hintText: "OrderIndex".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtOrderIndex,
      decoration: InputDecoration(labelText: 'OrderIndex'),
    );
  }

  Widget buildRowPassword() {
    return Column(children: [
      Row(
        children: [
          Text(
            "Set Password",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: "Poppins",
                color: Color(0xff353535)),
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.info_outline_rounded),
            onPressed: () => hintDialog('Set Password',
                'You can set password on your books to protect it from sharing to other people.'),
            color: Color(0xff353535),
          )
        ],
      ),
      SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
            color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          cursorColor: Color(0xff8A8A8A),
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xff8A8A8A)),
          keyboardType: TextInputType.visiblePassword,
          controller: txtPassword,
          decoration: InputDecoration(
              labelText: "Password".tr,
              // hintText: "Password".tr,
              contentPadding: const EdgeInsets.only(left: 10),
              hintStyle: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xff8A8A8A)),
              border: InputBorder.none),
        ),
      )
    ]);
    return TextFormField(
      controller: txtPassword,
      decoration: InputDecoration(labelText: 'Password'),
    );
  }

  Widget buildRowTitle() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'required_error'.tr;
          }
          return null;
        },
        controller: txtTitle,
        decoration: InputDecoration(
            labelText: "title".tr,
            // hintText: "title".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'required_error'.tr;
        }
        return null;
      },
      controller: txtTitle,
      decoration: InputDecoration(labelText: 'title'.tr),
    );
  }

  Widget buildRowRatio() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || int.tryParse(value) == null) {
            return 'valid_number_error'.tr;
          }

          return null;
        },
        controller: txtRatio,
        decoration: InputDecoration(
            labelText: "Ratio (second per letter)".tr,
            // hintText: "Ratio (second per letter)".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && double.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtRatio,
      decoration: InputDecoration(labelText: ''),
    );
  }

  Widget buildRowCaseType() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtCaseType,
      decoration: InputDecoration(labelText: 'CaseType'),
    );
  }

  Widget buildRowCountTime() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || int.tryParse(value) == null) {
            return 'valid_number_error'.tr;
          }

          return null;
        },
        controller: txtCountTime,
        decoration: InputDecoration(
            labelText: 'add_book_time_step'.tr,
            // hintText: "".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty || int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtCountTime,
      decoration: InputDecoration(labelText: 'CountTime'),
    );
  }

  Widget buildRowUnitTime() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtUnitTime,
      decoration: InputDecoration(labelText: 'UnitTime'),
    );
  }

  Widget buildRowBoxCount() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || int.tryParse(value) == null) {
            return 'valid_number_error'.tr;
          }

          return null;
        },
        controller: txtBoxCount,
        decoration: InputDecoration(
            labelText: 'Leithner box'.tr,

            // hintText: "Leithner box".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty || int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtBoxCount,
      decoration: InputDecoration(labelText: 'BoxCount'),
    );
  }

  Widget buildRowLanguageItemOne() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty || int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtLanguageItemOne,
      decoration: InputDecoration(labelText: 'LanguageItemOne'),
    );
  }

  Widget buildRowLanguageItemTwo() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty || int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtLanguageItemTwo,
      decoration: InputDecoration(labelText: 'LanguageItemTwo'),
    );
  }

  Widget buildRowLanguageItemThree() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty || int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtLanguageItemThree,
      decoration: InputDecoration(labelText: 'LanguageItemThree'),
    );
  }

  Widget buildRowRootGroupId(
      void Function(int? selectedRootGroupId)
          onChangeDropdownItemForRootGroupId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            'Folder',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: "Poppins",
                color: Color(0xff353535)),
          ),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedRootGroupId,
                items: _dropdownMenuItemsForRootGroupId,
                onChanged: onChangeDropdownItemForRootGroupId,
                validator: (value) {
                  if (value != null && int.parse(value.toString()) <= 0) {
                    return 'Select at least one item';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowImagePath() {
    return TextFormField(
      controller: txtImagePath,
      decoration: InputDecoration(labelText: 'ImagePath'),
    );
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    subgroup
      ..title = txtTitle.text
      ..ratio = double.tryParse(txtRatio.text)
      ..caseType = int.tryParse(txtCaseType.text)
      ..countTime = int.tryParse(txtCountTime.text)
      ..unitTime = int.tryParse(txtUnitTime.text)
      ..boxCount = int.tryParse(txtBoxCount.text)
      ..password = (subgroup.id == null && txtPassword.text.isNotEmpty)
          ? utf8.encode(txtPassword.text).toString()
          : txtPassword.text
      ..orderIndex =
          (txtOrderIndex.text.isNotEmpty) ? int.parse(txtOrderIndex.text) : 0
      ..languageItemOne = int.tryParse(txtLanguageItemOne.text)
      ..languageItemTwo = int.tryParse(txtLanguageItemTwo.text)
      ..languageItemThree = int.tryParse(txtLanguageItemThree.text)
      ..rootGroupId = _selectedRootGroupId
      ..imagePath = txtImagePath.text;

    if (subgroup.id == null) {
      final all = await SubGroup().select().orderBy('orderIndex').toList();
      for (var i = 0; i < all.length; i++) {
        all[i].orderIndex = i + 1;
        await all[i].save();
      }
      subgroup.orderIndex = 0;
    }
    if (subgroup.id == null &&
        subgroup.password != null &&
        subgroup.password!.isNotEmpty) {
      subgroup.passwordConfirmed = true;
    }
    await subgroup.save();
    if (subgroup.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(subgroup.saveResult.toString(),
          title: 'save SubGroup Failed!', callBack: () {});
    }
  }
}

class LessonAdd extends StatefulWidget {
  LessonAdd(this._lesson, {this.showAppBar = true});
  final bool showAppBar;
  final dynamic _lesson;
  @override
  State<StatefulWidget> createState() =>
      LessonAddState(_lesson as Lesson, showAppBar);
}

class LessonAddState extends State {
  LessonAddState(this.lesson, this.showAppBar);
  bool showAppBar;
  Lesson lesson;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtImagePath = TextEditingController();
  final TextEditingController txtStoryTitle = TextEditingController();
  final TextEditingController txtStoryDesc = TextEditingController();
  final TextEditingController txtStoryImagePath = TextEditingController();
  final TextEditingController txtStoryVoicePathOne = TextEditingController();
  final TextEditingController txtStoryVoicePathTwo = TextEditingController();
  final TextEditingController txtDescriptionTitle = TextEditingController();
  qu.QuillController descController = qu.QuillController.basic();
  qu.QuillController storyDescController = qu.QuillController.basic();
  final TextEditingController txtDescriptionDesc = TextEditingController();
  final TextEditingController txtDescriptionImagePath = TextEditingController();
  final TextEditingController txtOrderIndex = TextEditingController();
  final TextEditingController txtDescriptionVoicePathOne =
      TextEditingController();
  final TextEditingController txtDescriptionVoicePathTwo =
      TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForSubGroupId =
      <DropdownMenuItem<int>>[];
  int? _selectedSubGroupId;

  @override
  void initState() {
    // Here we will check input. if input is null then we create, but if it's not, its mean we should edit the card.
    txtOrderIndex.text =
        lesson.orderIndex == null ? '' : lesson.orderIndex.toString();
    txtTitle.text = lesson.title == null ? '' : lesson.title.toString();
    txtImagePath.text =
        lesson.imagePath == null ? '' : lesson.imagePath.toString();
    txtStoryTitle.text =
        lesson.storyTitle == null ? '' : lesson.storyTitle.toString();
    txtStoryDesc.text =
        lesson.storyDesc == null ? '' : lesson.storyDesc.toString();
    txtStoryImagePath.text =
        lesson.storyImagePath == null ? '' : lesson.storyImagePath.toString();
    txtStoryVoicePathOne.text = lesson.storyVoicePathOne == null
        ? ''
        : lesson.storyVoicePathOne.toString();
    txtStoryVoicePathTwo.text = lesson.storyVoicePathTwo == null
        ? ''
        : lesson.storyVoicePathTwo.toString();
    txtDescriptionTitle.text = lesson.descriptionTitle == null
        ? ''
        : lesson.descriptionTitle.toString();
    txtDescriptionDesc.text =
        lesson.descriptionDesc == null ? '' : lesson.descriptionDesc.toString();
    if (lesson.descriptionDesc != null) {
      final doc = qu.Document()..insert(0, lesson.descriptionDesc);

      try {
        descController = qu.QuillController(
            document: qu.Document.fromJson(jsonDecode(lesson.descriptionDesc!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        descController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    descController.addListener(() {
      var json = jsonEncode(descController.document.toDelta().toJson());
      //print(json);
      print(descController.document.toPlainText());
      txtDescriptionDesc.text = json;
    });
    if (lesson.storyDesc != null) {
      final doc = qu.Document()..insert(0, lesson.storyDesc);
      try {
        storyDescController = qu.QuillController(
            document: qu.Document.fromJson(jsonDecode(lesson.storyDesc!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        storyDescController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    storyDescController.addListener(() {
      var json = jsonEncode(storyDescController.document.toDelta().toJson());
      //print(json);
      print(storyDescController.document.toPlainText());
      txtStoryDesc.text = json;
    });
    txtDescriptionImagePath.text = lesson.descriptionImagePath == null
        ? ''
        : lesson.descriptionImagePath.toString();
    txtDescriptionVoicePathOne.text = lesson.descriptionVoicePathOne == null
        ? ''
        : lesson.descriptionVoicePathOne.toString();
    txtDescriptionVoicePathTwo.text = lesson.descriptionVoicePathTwo == null
        ? ''
        : lesson.descriptionVoicePathTwo.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForSubGroupId() async {
      final dropdownMenuItems =
          await SubGroup().select().toDropDownMenuInt('title');
      setState(() {
        _dropdownMenuItemsForSubGroupId = dropdownMenuItems;
        _selectedSubGroupId = lesson.subGroupId;
      });
    }

    if (_dropdownMenuItemsForSubGroupId.isEmpty) {
      buildDropDownMenuForSubGroupId();
    }
    void onChangeDropdownItemForSubGroupId(int? selectedSubGroupId) {
      setState(() {
        _selectedSubGroupId = selectedSubGroupId;
      });
    }

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: (lesson.id == null)
                  ? Text(
                      'add_lesson'.tr,
                      style: Get.theme.textTheme.headline1!
                          .copyWith(color: Colors.white),
                    )
                  : Text(
                      lesson.title ?? 'add_lesson'.tr,
                      style: Get.theme.textTheme.headline1!
                          .copyWith(color: Colors.white),
                    ))
          : null,
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (!showAppBar)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lesson.title ?? 'add_lesson'.tr,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 100,
                                  spreadRadius: 0.5)
                            ],
                            // border:
                            //     Border.all(color: Color(0xff8A8A8A), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text("Question",
                          //         style: TextStyle(
                          //           fontSize: 24,
                          //           fontWeight: FontWeight.w600,
                          //           fontFamily: "Poppins",
                          //         )),
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          buildRowTitle(),
                        ])),

                    ImagePath(txtImagePath: txtImagePath),

                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),

                    Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 100,
                                  spreadRadius: 0.5)
                            ],
                            border:
                                Border.all(color: Color(0xff8A8A8A), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("add_lesson_note1".tr,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          buildRowStoryTitle(),
                          SizedBox(
                            height: 10,
                          ),
                          qu.QuillToolbar.basic(
                              controller: storyDescController),
                          qu.QuillToolbar(
                            locale: Locale('en'),
                            children: [
                              Container(
                                //color: Colors.grey,
                                height: 300,
                                child: qu.QuillEditor.basic(
                                  controller: storyDescController,
                                  readOnly: false, // true for view only mode
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ImagePath(txtImagePath: txtStoryImagePath),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // buildRowStoryVoicePathOne(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: VoiceRecordViewPage(
                                voiceEditingController: txtStoryVoicePathOne),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // buildRowStoryVoicePathTwo(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: VoiceRecordViewPage(
                                voiceEditingController: txtStoryVoicePathTwo),
                          ),
                        ])),

                    // buildRowStoryDesc(),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // buildRowStoryImagePath(),
                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 100,
                                  spreadRadius: 0.5)
                            ],
                            border:
                                Border.all(color: Color(0xff8A8A8A), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("add_lesson_note2".tr,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          buildRowDescriptionTitle(),
                          SizedBox(
                            height: 10,
                          ),
                          qu.QuillToolbar.basic(controller: descController),
                          qu.QuillToolbar(
                            locale: Locale('en'),
                            children: [
                              Container(
                                // color: Colors.grey,
                                height: 300,
                                child: qu.QuillEditor.basic(
                                  controller: descController,
                                  readOnly: false, // true for view only mode
                                ),
                              )
                            ],
                          ),
                          // buildRowDescriptionDesc(),
                          SizedBox(
                            height: 10,
                          ),
                          // buildRowDescriptionImagePath(),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          ImagePath(txtImagePath: txtDescriptionImagePath),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // buildRowDescriptionVoicePathOne(),

                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: VoiceRecordViewPage(
                                voiceEditingController:
                                    txtDescriptionVoicePathOne),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // buildRowStoryVoicePathTwo(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: VoiceRecordViewPage(
                                voiceEditingController:
                                    txtDescriptionVoicePathTwo),
                          ),
                        ])),
                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff8A8A8A), width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        title: Text(
                          "More Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                          ),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                buildRowOrderIndex(),
                                // buildRowImagePath(),
                                SizedBox(
                                  height: 10,
                                ),
                                buildRowSubGroupId(
                                    onChangeDropdownItemForSubGroupId),

                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:
                                Color(0xff27187E), //background color of button
                            // side: BorderSide(
                            //     width: 3,
                            //     color: Colors.brown), //border width and color
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(
                                15) //content padding inside button
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.save),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Text(
                              (lesson.id == null)
                                  ? 'Make it!'.tr
                                  : "Save Edits",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            save();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowOrderIndex() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtOrderIndex,
      decoration: InputDecoration(labelText: 'OrderIndex'),
    );
  }

  Widget buildRowTitle() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'required_error'.tr;
          }
          return null;
        },
        controller: txtTitle,
        decoration: InputDecoration(
            labelText: 'title'.tr,
            hintText: "add_lesson_hint_title".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
  }

  Widget buildRowImagePath() {
    return TextFormField(
      controller: txtImagePath,
      decoration: InputDecoration(labelText: 'ImagePath'),
    );
  }

  Widget buildRowStoryTitle() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'required_error'.tr;
          }
          return null;
        },
        controller: txtStoryTitle,
        decoration: InputDecoration(
            labelText: 'title'.tr,
            hintText: "add_lesson_note1_title".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
    return TextFormField(
      controller: txtStoryTitle,
      decoration: InputDecoration(labelText: 'StoryTitle'),
    );
  }

  Widget buildRowStoryDesc() {
    return TextFormField(
      controller: txtStoryDesc,
      maxLines: null,
      minLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: 'StoryDesc'),
    );
  }

  Widget buildRowStoryImagePath() {
    return TextFormField(
      controller: txtStoryImagePath,
      decoration: InputDecoration(labelText: 'StoryImagePath'),
    );
  }

  Widget buildRowStoryVoicePathOne() {
    return TextFormField(
      controller: txtStoryVoicePathOne,
      decoration: InputDecoration(labelText: 'StoryVoicePathOne'),
    );
  }

  Widget buildRowStoryVoicePathTwo() {
    return TextFormField(
      controller: txtStoryVoicePathTwo,
      decoration: InputDecoration(labelText: 'StoryVoicePathTwo'),
    );
  }

  Widget buildRowDescriptionTitle() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'required_error'.tr;
          }
          return null;
        },
        controller: txtDescriptionTitle,
        decoration: InputDecoration(
            labelText: 'title'.tr,
            hintText: "add_lesson_note2_title".tr,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
    return TextFormField(
      controller: txtDescriptionTitle,
      decoration: InputDecoration(labelText: 'DescriptionTitle'),
    );
  }

  Widget buildRowDescriptionDesc() {
    return TextFormField(
      controller: txtDescriptionDesc,
      maxLines: null,
      minLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: 'DescriptionDesc'),
    );
  }

  Widget buildRowDescriptionImagePath() {
    return TextFormField(
      controller: txtDescriptionImagePath,
      decoration: InputDecoration(labelText: 'DescriptionImagePath'),
    );
  }

  Widget buildRowDescriptionVoicePathOne() {
    return TextFormField(
      controller: txtDescriptionVoicePathOne,
      decoration: InputDecoration(labelText: 'DescriptionVoicePathOne'),
    );
  }

  Widget buildRowDescriptionVoicePathTwo() {
    return TextFormField(
      controller: txtDescriptionVoicePathTwo,
      decoration: InputDecoration(labelText: 'DescriptionVoicePathTwo'),
    );
  }

  Widget buildRowSubGroupId(
      void Function(int? selectedSubGroupId)
          onChangeDropdownItemForSubGroupId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Book'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedSubGroupId,
                items: _dropdownMenuItemsForSubGroupId,
                onChanged: onChangeDropdownItemForSubGroupId,
                validator: (value) {
                  if (value != null && int.parse(value.toString()) <= 0) {
                    return 'Select at least one item';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    lesson
      ..title = txtTitle.text
      ..imagePath = txtImagePath.text
      ..storyTitle = txtStoryTitle.text
      ..storyDesc = txtStoryDesc.text
      ..storyImagePath = txtStoryImagePath.text
      ..storyVoicePathOne = txtStoryVoicePathOne.text
      ..storyVoicePathTwo = txtStoryVoicePathTwo.text
      ..descriptionTitle = txtDescriptionTitle.text
      ..descriptionDesc = txtDescriptionDesc.text
      ..descriptionImagePath = txtDescriptionImagePath.text
      ..descriptionVoicePathOne = txtDescriptionVoicePathOne.text
      ..descriptionVoicePathTwo = txtDescriptionVoicePathTwo.text
      ..orderIndex =
          (txtOrderIndex.text.isNotEmpty) ? int.parse(txtOrderIndex.text) : 0
      ..subGroupId = _selectedSubGroupId;
    // if (lesson.id == null) {
    //   final all = await Lesson().select().orderBy('orderIndex').toList();
    //   for (var i = 0; i < all.length; i++) {
    //     all[i].orderIndex = i + 1;
    //     await all[i].save();
    //   }
    //   lesson.orderIndex = 0;
    // }
    await lesson.save();
    if (lesson.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(lesson.saveResult.toString(),
          title: 'save Lesson Failed!', callBack: () {});
    }
  }
}

class TblCardAdd extends StatefulWidget {
  TblCardAdd(this._tblcard, {this.showAppBar = true});
  final bool showAppBar;
  final dynamic _tblcard;
  @override
  State<StatefulWidget> createState() =>
      TblCardAddState(_tblcard as TblCard, showAppBar);
}

class TblCardAddState extends State {
  TblCardAddState(this.tblcard, this.showAppBar);
  bool showAppBar;
  TblCard tblcard;
  final _formKey = GlobalKey<FormState>();
  qu.QuillController questionController = qu.QuillController.basic();
  qu.QuillController replyController = qu.QuillController.basic();
  qu.QuillController descController = qu.QuillController.basic();
  final TextEditingController txtQuestion = TextEditingController();
  final TextEditingController txtQuestionVoicePath = TextEditingController();
  final TextEditingController txtRatio = TextEditingController();
  final TextEditingController txtReply = TextEditingController();
  final TextEditingController txtReplyVoicePath = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDescriptionVoicePath = TextEditingController();
  final TextEditingController txtImagePath = TextEditingController();
  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();
  final TextEditingController txtOrderIndex = TextEditingController();
  final TextEditingController txtBoxNumber = TextEditingController();
  final TextEditingController txtBoxVisibleDate = TextEditingController();
  final TextEditingController txtTimeForBoxVisibleDate =
      TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForLessonId =
      <DropdownMenuItem<int>>[];
  int? _selectedLessonId;

  @override
  void initState() {
    txtOrderIndex.text =
        tblcard.orderIndex == null ? '' : tblcard.orderIndex.toString();
    txtQuestion.text =
        tblcard.question == null ? '' : tblcard.question.toString();
    txtQuestionVoicePath.text = tblcard.questionVoicePath == null
        ? ''
        : tblcard.questionVoicePath.toString();
    txtRatio.text = tblcard.ratio == null ? '' : tblcard.ratio.toString();
    txtReply.text = tblcard.reply == null ? '' : tblcard.reply.toString();
    txtReplyVoicePath.text =
        tblcard.replyVoicePath == null ? '' : tblcard.replyVoicePath.toString();
    txtDescription.text =
        tblcard.description == null ? '' : tblcard.description.toString();
    txtDescriptionVoicePath.text = tblcard.descriptionVoicePath == null
        ? ''
        : tblcard.descriptionVoicePath.toString();
    txtImagePath.text =
        tblcard.imagePath == null ? '' : tblcard.imagePath.toString();
    txtDateCreated.text = tblcard.dateCreated == null
        ? ''
        : UITools.convertDate(tblcard.dateCreated!);
    txtTimeForDateCreated.text = tblcard.dateCreated == null
        ? ''
        : UITools.convertTime(tblcard.dateCreated!);

    txtBoxNumber.text =
        tblcard.boxNumber == null ? '' : tblcard.boxNumber.toString();
    txtBoxVisibleDate.text = tblcard.boxVisibleDate == null
        ? ''
        : UITools.convertDate(tblcard.boxVisibleDate!);
    txtTimeForBoxVisibleDate.text = tblcard.boxVisibleDate == null
        ? ''
        : UITools.convertTime(tblcard.boxVisibleDate!);

    if (tblcard.question != null) {
      final doc = qu.Document()..insert(0, tblcard.question);

      try {
        questionController = qu.QuillController(
            document: qu.Document.fromJson(jsonDecode(tblcard.question!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        questionController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    questionController.addListener(() {
      var json = jsonEncode(questionController.document.toDelta().toJson());
      //print(json);
      // print(questionController.document.toPlainText());
      txtQuestion.text = json;
    });
    if (tblcard.reply != null) {
      final doc = qu.Document()..insert(0, tblcard.reply);

      try {
        replyController = qu.QuillController(
            document: qu.Document.fromJson(jsonDecode(tblcard.reply!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        replyController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    replyController.addListener(() {
      var json = jsonEncode(replyController.document.toDelta().toJson());
      //print(json);
      //  print(replyController.document.toPlainText());
      txtReply.text = json;
    });
    if (tblcard.description != null) {
      final doc = qu.Document()..insert(0, tblcard.description);

      try {
        descController = qu.QuillController(
            document: qu.Document.fromJson(jsonDecode(tblcard.description!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        descController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    descController.addListener(() {
      var json = jsonEncode(descController.document.toDelta().toJson());
      //print(json);
      // print(descController.document.toPlainText());
      txtDescription.text = json;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForLessonId() async {
      final dropdownMenuItems =
          await Lesson().select().toDropDownMenuInt('title');
      setState(() {
        _dropdownMenuItemsForLessonId = dropdownMenuItems;
        _selectedLessonId = tblcard.lessonId;
      });
    }

    if (_dropdownMenuItemsForLessonId.isEmpty) {
      buildDropDownMenuForLessonId();
    }
    void onChangeDropdownItemForLessonId(int? selectedLessonId) {
      setState(() {
        _selectedLessonId = selectedLessonId;
      });
    }

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: (tblcard.id == null)
                  ? Text(
                      'add_card'.tr,
                      style: Get.theme.textTheme.headline1!,
                    )
                  : Text(
                      questionController.plainTextEditingValue.text.trim() ??
                          'add_card'.tr,
                      style: Get.theme.textTheme.headline1!,
                    ))
          : null,
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (!showAppBar)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            tblcard.question ?? 'add_card'.tr,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff8A8A8A), width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Question",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          //buildRowQuestion(),
                          qu.QuillToolbar.basic(controller: questionController),
                          qu.QuillToolbar(
                            locale: Locale('en'),
                            children: [
                              Container(
                                //color: Colors.grey,
                                height: 150,
                                child: qu.QuillEditor.basic(
                                  controller: questionController,
                                  readOnly: false, // true for view only mode
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          // buildRowQuestionVoicePath(),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: VoiceRecordViewPage(
                                voiceEditingController: txtQuestionVoicePath),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: 10),
                    // buildRowOrderIndex(),
                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),

                    // buildRowAutoRecord(),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff8A8A8A), width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Answer",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          //buildRowQuestion(),
                          qu.QuillToolbar.basic(controller: replyController),
                          qu.QuillToolbar(
                            locale: Locale('en'),
                            children: [
                              Container(
                                //color: Colors.grey,
                                height: 300,
                                child: qu.QuillEditor.basic(
                                  controller: replyController,
                                  readOnly: false, // true for view only mode
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          // buildRowReplyVoicePath(),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: VoiceRecordViewPage(
                                voiceEditingController: txtReplyVoicePath),
                          ),
                        ],
                      ),
                    ),
                    // buildRowReply(),
                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    //  buildRowDescription(),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff8A8A8A), width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Description",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          //buildRowQuestion(),
                          qu.QuillToolbar.basic(controller: descController),
                          qu.QuillToolbar(
                            locale: Locale('en'),
                            children: [
                              Container(
                                //color: Colors.grey,
                                height: 300,
                                child: qu.QuillEditor.basic(
                                  controller: descController,
                                  readOnly: false, // true for view only mode
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          // buildRowDescriptionVoicePath(),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: VoiceRecordViewPage(
                                voiceEditingController:
                                    txtDescriptionVoicePath),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    // buildRowImagePath(),
                    Container(
                        decoration: BoxDecoration(
                            // border:
                            //     Border.all(color: Color(0xff8A8A8A), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Image",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          ImagePath(txtImagePath: txtImagePath),
                        ])),

                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    // SizedBox(height: 10),
                    //  buildRowDateCreated(),
                    //  buildRowExamDone(),
                    // buildRowBoxNumber(),
                    //  buildRowBoxVisibleDate(),

                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff8A8A8A), width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        title: Text(
                          "More Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                          ),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                buildRowLessonId(
                                    onChangeDropdownItemForLessonId),
                                SizedBox(height: 10),
                                buildRowSpellChecker(),
                                // SizedBox(height: 10),
                                // buildRowAutoPlay(),
                                SizedBox(height: 10),
                                buildRowRatio(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:
                                Color(0xff27187E), //background color of button
                            // side: BorderSide(
                            //     width: 3,
                            //     color: Colors.brown), //border width and color
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(
                                15) //content padding inside button
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.save),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Text(
                              (tblcard.id == null)
                                  ? 'Make it!'.tr
                                  : "Save Edits",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            save();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowAutoRecord() {
    return Row(
      children: <Widget>[
        Text('AutoRecord?'),
        Checkbox(
          value: tblcard.autoRecord ?? false,
          onChanged: (bool? value) {
            setState(() {
              tblcard.autoRecord = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowAutoPlay() {
    return Row(
      children: <Widget>[
        Text('AutoPlay?'),
        Checkbox(
          value: tblcard.autoPlay ?? false,
          onChanged: (bool? value) {
            setState(() {
              tblcard.autoPlay = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowOrderIndex() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtOrderIndex,
      decoration: InputDecoration(labelText: 'OrderIndex'),
    );
  }

  Widget buildRowSpellChecker() {
    return Row(
      children: <Widget>[
        Text('Spell Check?'),
        Checkbox(
          value: tblcard.spellChecker ?? false,
          onChanged: (bool? value) {
            setState(() {
              tblcard.spellChecker = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowQuestion() {
    return TextFormField(
      controller: txtQuestion,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 5,
      decoration: InputDecoration(labelText: 'Question'),
    );
  }

  Widget buildRowQuestionVoicePath() {
    return TextFormField(
      controller: txtQuestionVoicePath,
      decoration: InputDecoration(labelText: 'QuestionVoicePath'),
    );
  }

  Widget buildRowRatio() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && double.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtRatio,
      decoration: InputDecoration(labelText: 'Ratio'),
    );
  }

  Widget buildRowReply() {
    return TextFormField(
      controller: txtReply,
      maxLines: null,
      minLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: 'Reply'),
    );
  }

  Widget buildRowReplyVoicePath() {
    return TextFormField(
      controller: txtReplyVoicePath,
      decoration: InputDecoration(labelText: 'ReplyVoicePath'),
    );
  }

  Widget buildRowDescription() {
    return TextFormField(
      controller: txtDescription,
      maxLines: null,
      minLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: 'Description'),
    );
  }

  Widget buildRowDescriptionVoicePath() {
    return TextFormField(
      controller: txtDescriptionVoicePath,
      decoration: InputDecoration(labelText: 'DescriptionVoicePath'),
    );
  }

  Widget buildRowImagePath() {
    return TextFormField(
      controller: txtImagePath,
      decoration: InputDecoration(labelText: 'ImagePath'),
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  tblcard.dateCreated ??
                  DateTime.now();
              tblcard.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  tblcard.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    tblcard.dateCreated ??
                    DateTime.now();
                tblcard.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text = UITools.convertDate(tblcard.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    tblcard.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Widget buildRowExamDone() {
    return Row(
      children: <Widget>[
        Text('ExamDone?'),
        Checkbox(
          value: tblcard.examDone ?? false,
          onChanged: (bool? value) {
            setState(() {
              tblcard.examDone = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowBoxNumber() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtBoxNumber,
      decoration: InputDecoration(labelText: 'BoxNumber'),
    );
  }

  Widget buildRowBoxVisibleDate() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtBoxVisibleDate.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForBoxVisibleDate.text =
                UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtBoxVisibleDate.text) ??
                  tblcard.boxVisibleDate ??
                  DateTime.now();
              tblcard.boxVisibleDate = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtBoxVisibleDate.text) ??
                  tblcard.boxVisibleDate ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtBoxVisibleDate,
          decoration: InputDecoration(labelText: 'BoxVisibleDate'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForBoxVisibleDate.text =
                  UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtBoxVisibleDate.text) ??
                    tblcard.boxVisibleDate ??
                    DateTime.now();
                tblcard.boxVisibleDate = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtBoxVisibleDate.text =
                    UITools.convertDate(tblcard.boxVisibleDate!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForBoxVisibleDate.text}') ??
                    tblcard.boxVisibleDate ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForBoxVisibleDate,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Widget buildRowLessonId(
      void Function(int? selectedLessonId) onChangeDropdownItemForLessonId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Lesson'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedLessonId,
                items: _dropdownMenuItemsForLessonId,
                onChanged: onChangeDropdownItemForLessonId,
                validator: (value) {
                  if (value != null && int.parse(value.toString()) <= 0) {
                    return 'Select at least one item';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    // var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    // final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    // if (_dateCreated != null && _dateCreatedTime != null) {
    //   _dateCreated = _dateCreated.add(Duration(
    //       hours: _dateCreatedTime.hour,
    //       minutes: _dateCreatedTime.minute,
    //       seconds: _dateCreatedTime.second));
    // }
    // var _boxVisibleDate = DateTime.tryParse(txtBoxVisibleDate.text);
    // final _boxVisibleDateTime =
    //     DateTime.tryParse(txtTimeForBoxVisibleDate.text);
    // if (_boxVisibleDate != null && _boxVisibleDateTime != null) {
    //   _boxVisibleDate = _boxVisibleDate.add(Duration(
    //       hours: _boxVisibleDateTime.hour,
    //       minutes: _boxVisibleDateTime.minute,
    //       seconds: _boxVisibleDateTime.second));
    // }
    var visibleTime = DateTime.now();
    if (tblcard.id == null || tblcard.id == 0) {
      // Lesson? lesson = await Lesson()
      //     .select()
      //     .id
      //     .equals(_selectedLessonId!)
      //     .toSingle(loadParents: true);
      // var unitTimeAsMinute = 0;
      // switch (lesson!.plSubGroup!.unitTime!) {
      //   case 1:
      //     unitTimeAsMinute = 1;
      //     break;
      //   case 2:
      //     unitTimeAsMinute = 60;
      //     break;
      //   case 3:
      //     unitTimeAsMinute = 1440;
      //     break;
      // }
      // visibleTime = DateTime.now().add(
      //     Duration(minutes: lesson.plSubGroup!.countTime! * unitTimeAsMinute));
      visibleTime = DateTime.now();
    } else {
      visibleTime = tblcard.boxVisibleDate!;
    }

    tblcard
      ..question = txtQuestion.text
      ..questionVoicePath = txtQuestionVoicePath.text
      ..ratio = double.tryParse(txtRatio.text)
      ..reply = txtReply.text
      ..replyVoicePath = txtReplyVoicePath.text
      ..description = txtDescription.text
      ..descriptionVoicePath = txtDescriptionVoicePath.text
      ..imagePath = txtImagePath.text
      ..dateCreated = DateTime.now()
      ..boxNumber = 0
      ..orderIndex =
          txtOrderIndex.text.isNotEmpty ? int.parse(txtOrderIndex.text) : 0
      ..boxVisibleDate = visibleTime
      ..examDone = false
      ..lessonId = _selectedLessonId;
    await tblcard.save();
    if (tblcard.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(tblcard.saveResult.toString(),
          title: 'save TblCard Failed!', callBack: () {});
    }
  }
}

class TablehistoryAdd extends StatefulWidget {
  TablehistoryAdd(this._tablehistory);
  final dynamic _tablehistory;
  @override
  State<StatefulWidget> createState() =>
      TablehistoryAddState(_tablehistory as Tablehistory);
}

class TablehistoryAddState extends State {
  TablehistoryAddState(this.tablehistory);
  Tablehistory tablehistory;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtDateQuestion = TextEditingController();
  final TextEditingController txtTimeForDateQuestion = TextEditingController();
  final TextEditingController txtResultQuestion = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForTblCardId =
      <DropdownMenuItem<int>>[];
  int? _selectedTblCardId;

  @override
  void initState() {
    txtDateQuestion.text = tablehistory.dateQuestion == null
        ? ''
        : UITools.convertDate(tablehistory.dateQuestion!);
    txtTimeForDateQuestion.text = tablehistory.dateQuestion == null
        ? ''
        : UITools.convertTime(tablehistory.dateQuestion!);

    txtResultQuestion.text = tablehistory.resultQuestion == null
        ? ''
        : tablehistory.resultQuestion.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForTblCardId() async {
      final dropdownMenuItems =
          await TblCard().select().toDropDownMenuInt('question');
      setState(() {
        _dropdownMenuItemsForTblCardId = dropdownMenuItems;
        _selectedTblCardId = tablehistory.tblCardId;
      });
    }

    if (_dropdownMenuItemsForTblCardId.isEmpty) {
      buildDropDownMenuForTblCardId();
    }
    void onChangeDropdownItemForTblCardId(int? selectedTblCardId) {
      setState(() {
        _selectedTblCardId = selectedTblCardId;
      });
    }

    return Scaffold(
      appBar: AppBar(
          title: (tablehistory.id == null)
              ? Text(
                  'Add a new tablehistory',
                  style: Get.theme.textTheme.headline1!
                      .copyWith(color: Colors.white),
                )
              : Text(
                  'Edit tablehistory',
                  style: Get.theme.textTheme.headline1!
                      .copyWith(color: Colors.white),
                )),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    buildRowDateQuestion(),
                    buildRowResultQuestion(),
                    buildRowTblCardId(onChangeDropdownItemForTblCardId),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
                        }
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowDateQuestion() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateQuestion.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateQuestion.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateQuestion.text) ??
                  tablehistory.dateQuestion ??
                  DateTime.now();
              tablehistory.dateQuestion = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateQuestion.text) ??
                  tablehistory.dateQuestion ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateQuestion,
          decoration: InputDecoration(labelText: 'DateQuestion'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateQuestion.text =
                  UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateQuestion.text) ??
                    tablehistory.dateQuestion ??
                    DateTime.now();
                tablehistory.dateQuestion = DateTime(d.year, d.month, d.day)
                    .add(Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateQuestion.text =
                    UITools.convertDate(tablehistory.dateQuestion!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateQuestion.text}') ??
                    tablehistory.dateQuestion ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateQuestion,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Widget buildRowResultQuestion() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'valid_number_error'.tr;
        }

        return null;
      },
      controller: txtResultQuestion,
      decoration: InputDecoration(labelText: 'ResultQuestion'),
    );
  }

  Widget buildRowTblCardId(
      void Function(int? selectedTblCardId) onChangeDropdownItemForTblCardId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('TblCard'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedTblCardId,
                items: _dropdownMenuItemsForTblCardId,
                onChanged: onChangeDropdownItemForTblCardId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateQuestion = DateTime.tryParse(txtDateQuestion.text);
    final _dateQuestionTime = DateTime.tryParse(txtTimeForDateQuestion.text);
    if (_dateQuestion != null && _dateQuestionTime != null) {
      _dateQuestion = _dateQuestion.add(Duration(
          hours: _dateQuestionTime.hour,
          minutes: _dateQuestionTime.minute,
          seconds: _dateQuestionTime.second));
    }

    tablehistory
      ..dateQuestion = _dateQuestion
      ..resultQuestion = int.tryParse(txtResultQuestion.text)
      ..tblCardId = _selectedTblCardId;
    await tablehistory.save();
    if (tablehistory.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(tablehistory.saveResult.toString(),
          title: 'save Tablehistory Failed!', callBack: () {});
    }
  }
}
