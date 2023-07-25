import 'package:Fast_learning/constants/custom_color.dart';

import 'package:flutter/material.dart';

class MyTheme {
  Brightness? brightness;
  MaterialColor? primarySwatch;
  Color? primaryColor;
  TextTheme? textTheme;
  ButtonThemeData? buttonThemeData;
  InputDecorationTheme? inputDecorationTheme;
  TabBarTheme? tabBarTheme;
  MyTheme(
      {this.brightness,
      this.primarySwatch,
      this.primaryColor,
      this.textTheme,
      this.buttonThemeData,
      this.inputDecorationTheme,
      this.tabBarTheme});
}

class AppTheme {
  String name;
  MyTheme? theme;

  AppTheme(this.name, this.theme);
}

AppTheme myThemes({int index = 0, int inc_font_factor = 0}) {
  if (index == 0)
    return AppTheme(
        'Default',
        MyTheme(
            brightness: Brightness.light,
            primarySwatch: CustomColor.primaryMaterialColor,
            primaryColor: CustomColor.primaryMaterialColor,
            textTheme: TextTheme(
                headline1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                bodyText1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                subtitle1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                subtitle2: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                button: TextStyle(color: Colors.white, fontFamily: 'Sans')),
            buttonThemeData: ButtonThemeData(
              buttonColor: CustomColor.primaryColor,
              textTheme: ButtonTextTheme.primary,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              //textTheme: ButtonTextTheme.accent,
            ),
            inputDecorationTheme: new InputDecorationTheme(
              fillColor: Color.fromRGBO(100, 140, 255, 1.0),
              filled: false,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            tabBarTheme: TabBarTheme(
              labelPadding: EdgeInsets.all(5.0),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
            )));
  else if (index == 1)
    return AppTheme(
        'Teal',
        MyTheme(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            primaryColor: Colors.teal,
            textTheme: TextTheme(
                headline1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                bodyText1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                subtitle1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                subtitle2: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                button: TextStyle(color: Colors.white, fontFamily: 'Sans')),
            buttonThemeData: ButtonThemeData(
              buttonColor: Color.fromRGBO(255, 213, 79, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              textTheme: ButtonTextTheme.primary,
            ),
            inputDecorationTheme: new InputDecorationTheme(
              fillColor: Color.fromRGBO(100, 140, 255, 1.0),
              filled: false,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            tabBarTheme: TabBarTheme(
              labelPadding: EdgeInsets.all(5.0),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
            )));
  else if (index == 2)
    return AppTheme(
        'Orange',
        MyTheme(
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            primaryColor: Colors.orange,
            textTheme: TextTheme(
                headline1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                bodyText1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                subtitle1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                subtitle2: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                button: TextStyle(color: Colors.white, fontFamily: 'Sans')),
            buttonThemeData: ButtonThemeData(
              buttonColor: Color.fromRGBO(100, 140, 255, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // textTheme: ButtonTextTheme.accent,
            ),
            inputDecorationTheme: new InputDecorationTheme(
              fillColor: Color.fromRGBO(100, 140, 255, 1.0),
              filled: false,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            tabBarTheme: TabBarTheme(
              labelPadding: EdgeInsets.all(5.0),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
            )));
  else if (index == 4)
    return AppTheme(
        'Perp',
        MyTheme(
            brightness: Brightness.light,
            primarySwatch: MaterialColor(0xFF4529E3, const {
              50: Color(0xFF4529E3),
              100: const Color(0xFF4529E3),
              200: const Color(0xFF4529E3),
              300: const Color(0xFF4529E3),
              400: const Color(0xFF4529E3),
              500: const Color(0xFF4529E3),
              600: const Color(0xFF4529E3),
              700: const Color(0xFF4529E3),
              800: const Color(0xFF4529E3),
              900: const Color(0xFF4529E3)
            }),
            primaryColor: Color(0xFF4529E3),
            textTheme: TextTheme(
                headline1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                bodyText1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                subtitle1: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                subtitle2: TextStyle(
                    color: CustomColor.grey,
                    fontFamily: 'Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                button: TextStyle(color: Colors.white, fontFamily: 'Sans')),
            buttonThemeData: ButtonThemeData(
              buttonColor: Color(0xFF4529E3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              textTheme: ButtonTextTheme.primary,
            ),
            inputDecorationTheme: new InputDecorationTheme(
              fillColor: Color.fromRGBO(100, 140, 255, 1.0),
              filled: false,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            tabBarTheme: TabBarTheme(
              labelPadding: EdgeInsets.all(5.0),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
            )));
  else
    return AppTheme(
        'Dark',
        MyTheme(
            brightness: Brightness.dark,
            primaryColor: Colors.black,
            textTheme: TextTheme(
                bodyText2: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                headline1: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                bodyText1: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                subtitle1: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
                subtitle2: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal),
                button: TextStyle(color: Colors.white, fontFamily: 'Sans')),
            buttonThemeData: ButtonThemeData(
              buttonColor: Color.fromRGBO(100, 140, 255, 1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // textTheme: ButtonTextTheme.accent,
            ),
            inputDecorationTheme: new InputDecorationTheme(
              fillColor: Color.fromRGBO(100, 140, 255, 1.0),
              filled: false,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            tabBarTheme: TabBarTheme(
              labelPadding: EdgeInsets.all(5.0),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
            )));
}
