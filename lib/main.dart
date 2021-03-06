import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:syboard/routes/notifications.dart';
import 'package:syboard/routes/profile/account_settings/account_delete.dart';
import 'package:syboard/routes/profile/buy_sell_history.dart';

import 'package:syboard/routes/search_results.dart';
import 'package:syboard/models/user_obj.dart';
import 'package:syboard/routes/profile/account_settings/account_change_avatar.dart';
import 'package:syboard/routes/profile/account_settings/account_change_name.dart';
import 'package:syboard/routes/profile/account_settings/account_change_password.dart';
import 'package:syboard/routes/profile/edit_account.dart';
import 'package:syboard/routes/sell_product.dart';

import 'package:syboard/routes/signup.dart';
import 'package:syboard/routes/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syboard/routes/login.dart';
import 'package:syboard/routes/walkthrough.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'package:syboard/services/auth.dart';
import 'package:syboard/views/sell_product/add_product.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> init = Firebase.initializeApp();
  //await Firebase.initializeApp();
  runApp(MyFirebaseApp(init: init));
}

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key, this.init}) : super(key: key);

  final Future<FirebaseApp>? init;

  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                    'No Firebase Connection: ${snapshot.error.toString()}'),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          FlutterError.onError =
              FirebaseCrashlytics.instance.recordFlutterError;
          return AppBase();
        }
        return const MaterialApp(
          home: Center(
            child: Text('Connecting to Firebase'),
          ),
        );
      },
    );
  }
}

class AppBase extends StatelessWidget {
  const AppBase({
    Key? key,
  }) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserObj?>.value(
        initialData: null,
        value: AuthService().getCurrentUser,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: <NavigatorObserver>[observer],
          routes: {
            '/': (context) => Index(analytics: analytics, observer: observer),
            '/walkthrough': (context) =>
                WalkThrough(analytics: analytics, observer: observer),
            '/welcome': (context) =>
                Welcome(analytics: analytics, observer: observer),
            '/login': (context) =>
                Login(analytics: analytics, observer: observer),
            '/signup': (context) =>
                SignUp(analytics: analytics, observer: observer),
            '/edit_account': (context) =>
                EditAccount(analytics: analytics, observer: observer),
            '/notifications': (context) =>
                Notifications(analytics: analytics, observer: observer),

            '/search_result': (context) => SearchResult(
                analytics: analytics, observer: observer, searchQuery: ""),
            '/profile/change_password': (context) => AccountSettingsPassword(),
            '/profile/change_name': (context) =>
                AccountSettingsName(), // TO DO: add analytics
            '/profile/change_avatar': (context) => AccountSettingsPP(),
             '/profile/account_delete': (context) => AccountDeletePP(),
            '/sell_product': (context) => SellProduct(),
            '/sell_product/add_product': (context) => AddProduct(),
            '/profile/buy_sell_history': (context) => BuySellHistory()
          },
        ));
  }
}
