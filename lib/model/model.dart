import 'dart:convert';

import 'package:Fast_learning/model/custom_widgets.dart';
import 'package:Fast_learning/zcomponent/common_widget/hintdialog.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as qu;
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import '../tools/helper.dart';
import '../voice_record_view_page.dart';
import 'view.list.dart';
import '../voice_record.dart';
part 'model.g.dart';
part 'model.g.view.dart';

const tableRootGroup = SqfEntityTable(
    tableName: 'rootGroup',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // declare fields
    fields: [
      SqfEntityField('serverId', DbType.integer),
      SqfEntityField('videoUrl', DbType.text),
      SqfEntityField('serverSync', DbType.bool),
      SqfEntityField('title', DbType.text),
      SqfEntityField('imagePath', DbType.text),
    ]);
const tableSubGroup = SqfEntityTable(
    tableName: 'subGroup',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // declare fields
    fields: [
      SqfEntityField('serverId', DbType.integer),
      SqfEntityField('orderIndex', DbType.integer),
      SqfEntityField('videoUrl', DbType.text),
      SqfEntityField('serverSync', DbType.bool),
      SqfEntityField('title', DbType.text),
      SqfEntityField(
        'ratio',
        DbType.real,
      ),
      SqfEntityField('caseType', DbType.integer),
      SqfEntityField('countTime', DbType.integer),
      SqfEntityField('password', DbType.text),
      SqfEntityField('passwordConfirmed', DbType.bool),
      SqfEntityField('unitTime', DbType.integer),
      SqfEntityField('boxCount', DbType.integer),
      SqfEntityField('languageItemOne', DbType.integer),
      SqfEntityField('languageItemTwo', DbType.integer),
      SqfEntityField('languageItemThree', DbType.integer),
      SqfEntityFieldRelationship(
          parentTable: tableRootGroup,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 0), //
      SqfEntityField('imagePath', DbType.text),
    ]);
const tableLesson = SqfEntityTable(
    tableName: 'lesson',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // declare fields
    fields: [
      SqfEntityField('serverId', DbType.integer),
      SqfEntityField('orderIndex', DbType.integer),
      SqfEntityField('serverSync', DbType.bool),
      SqfEntityField('title', DbType.text),
      SqfEntityField('videoUrl', DbType.text),
      SqfEntityField('imagePath', DbType.text),
      SqfEntityField('storyTitle', DbType.text),
      SqfEntityField('storyDesc', DbType.text),
      SqfEntityField('storyImagePath', DbType.text),
      SqfEntityField('storyVoicePathOne', DbType.text),
      SqfEntityField('storyVoicePathTwo', DbType.text),
      SqfEntityField('descriptionTitle', DbType.text),
      SqfEntityField('descriptionDesc', DbType.text),
      SqfEntityField('descriptionImagePath', DbType.text),
      SqfEntityField('descriptionVoicePathOne', DbType.text),
      SqfEntityField('descriptionVoicePathTwo', DbType.text),
      SqfEntityFieldRelationship(
          parentTable: tableSubGroup,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 0), //
    ]);

const tableCard = SqfEntityTable(
    tableName: 'tblCard',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // declare fields
    fields: [
      SqfEntityField('serverId', DbType.integer),
      SqfEntityField('orderIndex', DbType.integer),
      SqfEntityField('serverSync', DbType.bool),
      SqfEntityField('videoUrl', DbType.text),
      SqfEntityField('spellChecker', DbType.bool, defaultValue: false),
      SqfEntityField('question', DbType.text),
      SqfEntityField('questionVoicePath', DbType.text),
      SqfEntityField('ratio', DbType.real),
      SqfEntityField('reply', DbType.text),
      SqfEntityField('replyVoicePath', DbType.text),
      SqfEntityField('description', DbType.text),
      SqfEntityField('descriptionVoicePath', DbType.text),
      SqfEntityField('imagePath', DbType.text),
      SqfEntityField('dateCreated', DbType.datetime),
      SqfEntityField('reviewStart', DbType.bool, defaultValue: false),
      SqfEntityField('examDone', DbType.bool, defaultValue: false),
      SqfEntityField('autoPlay', DbType.bool, defaultValue: true),
      SqfEntityField('autoRecord', DbType.bool, defaultValue: true),
      SqfEntityField('boxNumber', DbType.integer, defaultValue: 0),
      SqfEntityField('boxVisibleDate', DbType.datetime),
      SqfEntityFieldRelationship(
          parentTable: tableLesson,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 0), //
    ]);
const tableHistory = SqfEntityTable(
    tableName: 'tablehistory',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // declare fields
    fields: [
      SqfEntityField('serverId', DbType.integer),
      SqfEntityField('serverSync', DbType.bool),
      SqfEntityField('replyVoicePath', DbType.text),
      SqfEntityField('reply', DbType.text),
      SqfEntityField('dateQuestion', DbType.datetime),
      SqfEntityField('resultQuestion', DbType.integer),
      SqfEntityField('replyTimeInSecond', DbType.integer),
      SqfEntityField('goodTimeInSecond', DbType.integer),
      SqfEntityField('beforeBoxNumber', DbType.integer),
      SqfEntityField('nextBoxNumber', DbType.integer),
      SqfEntityFieldRelationship(
          parentTable: tableCard,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 0), //
    ]);
const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);
@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'MyDbModel', // optional
    databaseName: 'sampleORM.db',
    password:
        null, // You can set a password if you want to use crypted database
    // (For more information: https://github.com/sqlcipher/sqlcipher)

    // put defined tables into the tables list.
    databaseTables: [
      tableRootGroup,
      tableSubGroup,
      tableLesson,
      tableCard,
      tableHistory
    ],
    // You can define tables to generate add/edit view forms if you want to use Form Generator property
    formTables: [
      tableRootGroup,
      tableSubGroup,
      tableLesson,
      tableCard,
      tableHistory
    ],
    // put defined sequences into the sequences list.
    sequences: [seqIdentity],
    bundledDatabasePath:
        null // 'assets/sample.db' // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
    );
