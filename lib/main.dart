import 'dart:io';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/controllers/book_controller.dart';
import 'package:Fast_learning/controllers/in_progress/in_progress_book_controller.dart';
import 'package:Fast_learning/controllers/lessons_controller.dart';
import 'package:Fast_learning/controllers/review_controller.dart';
import 'package:Fast_learning/controllers/translation_controller.dart';
import 'package:Fast_learning/firebase_options.dart';
import 'package:Fast_learning/leitner_box/main.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/nested_navigator/app.dart';
import 'package:Fast_learning/pages/home/home.dart';
import 'package:Fast_learning/services/in_app_purchase_api.dart';
import 'package:Fast_learning/services/local_notifications.dart';
import 'package:Fast_learning/speed_controller.dart';
import 'package:Fast_learning/zcomponent/figapp.dart';
import 'package:Fast_learning/zcomponent/homepage/folder/controller/foldercontroller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import 'controllers/add_leitner_controller.dart';
import 'controllers/cards_controller.dart';
import 'controllers/download_controller.dart';
import 'controllers/inapp_purchase_controller.dart';
import 'controllers/music_controller.dart';
import 'controllers/theme_controller.dart';
import 'tools/tools.dart';
import 'package:path_provider/path_provider.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// NotificationAppLaunchDetails? notificationAppLaunchDetails;
// int notifId = 1;

//? This should be Top level function
@pragma('vm:entry-point')
Future<void> _firebaseMessBackgroundHand(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  String title = notification?.title ?? '';
  String body = notification?.body ?? '';
  if (notification == null) return;
  print('--- background notification');
  print(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: Platform.isIOS ? 'fast-learning' : null,
      options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessBackgroundHand);
  LocalNotifications.init();
  await GetStorage.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool disableApp = prefs.getBool('disableApp') ?? false;
  // http.post(Uri.parse('http://tagweb.ir/leitner/intract/getprice'), body: {
  //   'xOsType': '1',
  //   'xBundleId': 'com.tagweb.canada'
  // }).then((response) {
  //   var body = jsonDecode(response.body);
  //   print(body['xPrice']);
  //   if (body['xPrice'] > 0) {
  //     prefs.setBool('disableApp', true);
  //     Future.delayed(const Duration(milliseconds: 1000), () {
  //       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //     });
  //   } else {
  //     prefs.setBool('disableApp', false);
  //   }
  // });
  // final expireDate = DateTime(2022, 05, 01);
  // final now = DateTime.now();
  // final difference = now.difference(expireDate).inDays;
  // if (difference >= 0 || now.isAfter(expireDate) || disableApp == true) {
  //   return;
  // }
  if (prefs.getString(Preference.token) == null) {
    prefs.setString(Preference.token, Uuid().v4());
  }

  debugPrintEndFrameBanner = false;
  await runSamples();
  Get.put(ThemeContoller());
  Get.put(CardsController());
  Get.put(SpeedController());
  Get.put(MusicController());
  Get.put(AddLeitnerController());
  Get.put(DownloadController());
  Get.put(QuestionReviewSpeedController());
  Get.put(ReplyReviewSpeedController());
  Get.put(DescriptionReviewSpeedController());
  Get.put(InAppPurchaseController());
  Get.put(FolderController());
  Get.put(MainLessonsController());
  Get.put(MainBookController());
  Get.put(MainReviewController());
  Get.put(TranslationController());

  Get.put(InProgressBookController());

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //**********************workmanager */
  Workmanager().initialize(
      // The top level function, aka callbackDispatcher
      callbackDispatcher,
      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: false);
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "4",
    "simplePeriodicTask",
    frequency: Duration(minutes: 60),
  );
  await InAppPurcahseApi.init();
//****************** */
  // runApp(MyApp(await getCurrentLocal()));
  runApp(FigApp(await getCurrentLocal()));
  // runApp(MyAppRedesigned());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    List<TblCard>? cards = await TblCard()
        .select()
        .boxVisibleDate
        .lessThan(DateTime.now())
        .and
        .examDone
        .equals(false)
        .and
        .reviewStart
        .equals(true)
        .toList();
    if (cards.length > 0) {
      var body = 'You have ${cards.length.toString()} cards ready now';
      // notificationAppLaunchDetails = await flutterLocalNotificationsPlugin
      //     .getNotificationAppLaunchDetails();
      // await initNotifications(flutterLocxalNotificationsPlugin);
      // requestIOSPermissions(flutterLocalNotificationsPlugin);
      // await showNotification(flutterLocalNotificationsPlugin, body);
    }

    return Future.value(true);
  });
}

Future<Locale> getCurrentLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var curerrentLocal = prefs.getString(Preference.language);
  if (curerrentLocal == null || curerrentLocal == 'en') {
    return Locale('en', 'US');
  } else {
    return Locale('fa', 'IR');
  }
}

//برای ایجاد تغییرات بانک در ورژن های جدید اجرای این متد الزامی است
Future runSamples() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final file = await rootBundle.loadString("assets/zip/group1.aes");
  ByteData bytes = await rootBundle.load("assets/zip/group1.aes");
  final file = await writeToFile(bytes);
  // print('asd ${file.path}');
  final category = await RootGroup().select().toCount();
  if (category == 0) {
    final rootgroup = RootGroup(imagePath: '', title: 'Template Group');
    await rootgroup.save();
    RootGroup(imagePath: '', title: 'My Downloads').save();
    // final file = File("zip/group1.aes");
    // ByteData bytes = await rootBundle.load('assets/zip/group1.aes');
    // print(bytes);
    unzipFiles(rootGroup: rootgroup, givenPath: file.path);
  } else {
    // final listgroup = await RootGroup().select().toList();
    // print('asd id ${listgroup[0].id}');
    // // final file = File("assets/zip/group1.aes");
    // // print(file.path);
    // unzipFiles(listgroup[0], givenPath: file.path);
    // DownloadController().showNew();

    print(
        'There is  already categories in the database.. addCategories will not run');
  }
}

Future<File> writeToFile(ByteData data) async {
  final buffer = data.buffer;
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  var filePath =
      tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
  return new File(filePath)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

class MyApp extends StatelessWidget {
  final Locale currentLocal;
  final themeController = Get.put(ThemeContoller());
  MyApp(this.currentLocal);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // WidgetsFlutterBinding.ensureInitialized();
    // loadAsset().then((path) {
    //   // await unzipFiles(widget.rootGroup);
    //   print('pqaht is $path');
    // });
    // final rootgroup = RootGroup();
    // rootgroup
    //   ..title = 'New'
    //   ..save().then((value) {
    //     // unzipFiles(rootgroup, givenPath: file.path);
    //   });

    // DefaultAssetBundle.of(context)
    //     .loadString("assets/zip/group1.aes")
    //     .then((path) {
    //   print('paht is $path');
    // });

    //themeController.buildThemeData();

    return Obx(() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Messages(), // your translations
        locale: currentLocal, // translations will be displayed in that locale
        fallbackLocale: Locale('en', 'UK'),
        title: 'Fast Learning',
        theme: themeController.themeData.value,
        // home: Home()
        home: ShowCaseWidget(
          onStart: (p0, p1) {
            SharedPreferences.getInstance().then((prefs) {});
          },
          onFinish: () {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setBool(Preference.show_hint_traning_page, false);
              prefs.setBool(Preference.show_hint_setting_page, false);
            });
          },
          builder: Builder(builder: (context) => Home()),
        )));
  }
}

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'lang_question': 'Language of Question',
          'lang_answer': 'Language of Answer',
          'lang_description': 'Language of Description',
          'number_subgroup': 'Subgroups',
          'import_books_from_link': 'Import Books From Link',
          'import_lessons_from_link': 'Import Lessons From Link',
          'card_numbers': 'Cards numbers',
          'question': 'Question',
          'answer': 'Answer',
          'description': 'Description',
          'picture': 'Picture',
          'camera': 'Camera',
          'gallery': 'Gallery',
          'days': 'Days',
          'houres': 'Houres',
          'minutes': 'Minutes',
          'language': 'Language',
          'subtitle_change_language': 'Click to change language',
          'setting': 'Setting',
          'profile': 'Profile',
          'review': 'Review',
          'training': 'Training',
          'lessons': 'Lessons',
          'lesson_count': 'Lesson Count',
          'books': 'Books',
          'courses': 'Courses',
          'cards': 'Cards',
          'reply': 'Reply',
          'example': 'Example',
          'card_ready_count': 'Cards ready today',
          'back': 'Back',
          'warning': 'Warning',
          'card_end_message': 'All cards were reviewed',
          'date_created': 'Created Time',
          'time_question': 'Question Time',
          'add_book': 'Add Book',
          'save': 'Save',
          'add_group': 'Add Group',
          'add_lesson': 'Add Lesson',
          'add_lesson_hint_title': 'Name of the lesson',
          'add_lesson_note1': 'Note 1',
          'add_lesson_note1_title': 'Enter title of first note',
          'add_lesson_note2': 'Note 2',
          'add_lesson_note2_title': 'Enter title of second note',
          'add_book_time_step': 'Time Step',
          'add_card': 'Make New Flashcard',
          'valid_number_error': 'Please Enter valid number',
          'required_error': 'Required Field',
          'title': 'Title',
          'too_long_msg': 'You spent a lot of time',
          'box_number': 'Box Number',
          'learned': 'Learned',
          'select_file': 'Select File',
          'required_select_zip_file': 'Select Zip Backup File Is Required!',
          'required_wrong_file':
              'Your File Format Is Wrong!\n It Should End With ".aes"',
          'difficult_question_msg': 'You answered late',
          'music_select_file_required': 'Select Mp3 File Is Required!',
          'enter_password': 'Enter Password',
          'wrong_password': 'Wrong Password',
          'easy': 'Easy',
          'very_easy': 'Very easy',
          'medium': 'Medium',
          'hard': 'Hard',
          'dont_know': 'I do not know',
          'dont_ask': "Don't ask again",
          'delete_msg': "Are you sure?",
          'denied_msg': "You have not permission",
          'change_password': "Change Password",
          'ex_time': 'Expected Time',
          'your_time': 'Your Time',
          'result': 'Result',
          'second': 'Second',
          'position': 'Position',
          'set_password': 'Set Password',
          'import_books': 'Import Books',
          'export_selected_books': 'Export Selected Books',
          'export_all_books': 'Export All Books',
          'import_lessons': 'Import Lessons',
          'export_selected_lessons': 'Export Selected Lessons',
          'export_all_lessons': 'Export All Lessons',
          'theme': 'Theme',
        },
        // 'fa_IR': {
        // 'number_subgroup': 'تعداد زیر گروه',
        // 'theme': 'قالب',
        // 'card_numbers': 'تعداد کارت ها',
        //   'question': 'پرسش',
        //   'answer': 'پاسخ',
        //   'description': 'توضیحات',
        //   'picture': 'عکس',
        //   'camera': 'دوربین',
        //   'gallery': 'گالری',
        //   'days': 'روز',
        //   'houres': 'ساعت',
        //   'minutes': 'دقیقه',
        //   'language': 'زبان',
        //   'subtitle_change_language': 'برای تغییر زبان کلیک کنید',
        //   'setting': 'تنظیمات',
        //   'profile': 'پروفایل',
        //   'review': 'مرور',
        //   'training': 'آموزش',
        //   'lessons': 'درس ها',
        //   'lesson_count': 'تعداد دروس',
        //   'books': 'کتابها',
        //   'courses': 'دوره ها',
        //   'cards': 'کارتها',
        //   'reply': 'پاسخ',
        //   'example': 'مثال',
        //   'card_ready_count': 'کارتهای آماده امروز',
        //   'back': 'برگشت',
        //   'warning': 'هشدار',
        //   'card_end_message': 'همه کارتها را مشاهده کردید ',
        //   'date_created': 'تاریخ ایجاد',
        //   'time_question': 'زمان پرسش مجدد',
        //   'add_book': 'ثبت کتاب جدید',
        //   'save': 'ثبت',
        //   'add_group': 'ثبت گروه جدید',
        //   'add_lesson': 'ثبت درس',
        //   'add_card': 'ثبت کارت',
        //   'valid_number_error': 'لطفا عدد وارد کنید',
        //   'required_error': 'تکمیل فیلد الزامی است',
        //   'title': 'عنوان',
        //   'too_long_msg': 'زیادی کشش دادی',
        //   'box_number': 'شماره جعبه',
        //   'learned': 'یاد گرفته شده',
        //   'select_file': 'انتخاب فایل',
        //   'required_select_zip_file':
        //       'انتخاب فایل فشرده مناسب حاوی نسخه های پشتیبان الزامی است !',
        //   'difficult_question_msg': 'دیر پاسخ دادی',
        //   'music_select_file_required': 'انتخاب فایل با فرمت mp3 الزامی است',
        //   'enter_password': 'پسورد',
        //   'wrong_password': 'پسورد اشتباه است',
        //   'easy': 'ساده',
        //   'very_easy': 'خیلی ساده',
        //   'medium': 'متوسط',
        //   'hard': 'سخت',
        //   'dont_know': 'بلد نیستم',
        //   'dont_ask': "بلدم،دیگه نپرس",
        //   'delete_msg': "از حذف اطلاعات اطمینان دارید؟",
        //   'denied_msg': "شما مجوز این عملیات را ندارید",
        //   'change_password': "تغییر پسورد",
        //   'ex_time': 'زمان مورد انتظار',
        //   'your_time': 'زمان شما',
        //   'result': 'نتیجه',
        //   'second': 'ثانیه',
        //   'position': 'جایگاه',
        //   'set_password': 'پسورد جدید',
        //   'import_books': 'وارد کردن کتابها ',
        //   'export_selected_books': 'تهیه خروجی انتخابی',
        //   'export_all_books': 'تهیه خروجی کلیه کتابها',
        //   'import_lessons': 'وارد کردن دروس',
        //   'export_selected_lessons': 'تهیه خروجی دروس انتخابی',
        //   'export_all_lessons': 'تهیه خروجی همه دروس',
        // }
      };
}
