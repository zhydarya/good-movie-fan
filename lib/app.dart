import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/catalog.dart';
import 'package:good_movie_fan/page/home.dart';
import 'package:good_movie_fan/preferences/preferences.dart';
import 'package:good_movie_fan/strings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class GoodMovieFanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => SharedPreferences.getInstance()),
        ChangeNotifierProxyProvider<SharedPreferences, Preferences>(
          create: (context) => Preferences(),
          update: (context, sharedPreferences, preferences) {
            return preferences..sharedPreferences = sharedPreferences;
          },
        ),
      ],
      child: MaterialAppConsumer(),
    );
  }
}

class MaterialAppConsumer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Catalog(),
      child: MaterialApp(
        title: Strings.appTitle,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: context.select<Preferences, ThemeMode>(
            (preferences) => preferences.themeMode),
        home: Home(NavigationPage.home),
        //TODO add Settings to be able to switch theme mode from any screen
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => Home(NavigationPage.home),
        //   '/settings': (context) => Settings(),
        // },
        navigatorObservers: [routeObserver],
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        canvasColor: Colors.pink[50],
        scaffoldBackgroundColor: Colors.indigo[100],
        splashColor: Colors.indigo[100],
        dialogBackgroundColor: Colors.pink[50],
        shadowColor: Colors.indigo[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: Colors.indigo[200],
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Colors.indigo[300]),
        ),
        textTheme: TextTheme(
          headline5: TextStyle(color: Colors.indigo[600]),
          headline6: TextStyle(color: Colors.indigo[900]),
          subtitle1: TextStyle(color: Colors.indigo[900]),
          subtitle2: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[900],
          ),
          bodyText1: TextStyle(color: Colors.indigo[700]),
          bodyText2: TextStyle(color: Colors.grey[850]),
          caption: TextStyle(color: Colors.grey[850]),
          button: TextStyle(color: Colors.white),
        ),
        cardTheme: CardTheme(
            color: Colors.purple[50],
            shadowColor: Colors.pink[900],
            elevation: 8.0),
        iconTheme: const IconThemeData(color: Colors.indigo),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.indigo[100],
            focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink[900])),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.pink[900]),
            ),
            errorStyle: TextStyle(color: Colors.pink[900])),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.pink[800],
          unselectedItemColor: Colors.indigo[100],
        ),
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(
            color: Colors.pink[50],
          ),
        )
        /* light theme settings */
        );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      canvasColor: Colors.pink[900],
      scaffoldBackgroundColor: Colors.indigo[900],
      splashColor: Colors.indigo[900],
      dialogBackgroundColor: Colors.pink[900],
      shadowColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      buttonColor: Colors.indigo,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Colors.indigo),
      ),
      textTheme: TextTheme(
        headline5: TextStyle(color: Colors.indigo[300]),
        headline6: TextStyle(color: Colors.indigo[200]),
        subtitle1: TextStyle(color: Colors.pink[50]),
        subtitle2: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Colors.pink[700],
        ),
        bodyText1: TextStyle(color: Colors.indigo[100]),
        bodyText2: TextStyle(color: Colors.white),
        caption: TextStyle(color: Colors.white),
        button: TextStyle(color: Colors.white),
      ),
      cardTheme: CardTheme(
          color: Colors.grey[900], shadowColor: Colors.pink[100], elevation: 8),
      iconTheme: const IconThemeData(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.indigo,
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pink[200])),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink[200]),
          ),
          errorStyle: TextStyle(color: Colors.pink[200])),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.pink[800],
        unselectedItemColor: Colors.indigo[900],
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: TextStyle(
          color: Colors.pink[700],
        ),
      ),
    );
  }
}
