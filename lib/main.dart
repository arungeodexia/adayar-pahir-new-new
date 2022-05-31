// @dart=2.9
import 'package:ACI/translations/codegen_loader.g.dart';
import 'package:ACI/utils/language.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ACI/Bloc/Myhomepage/myhomepage_bloc.dart';
import 'package:ACI/Bloc/Myhomepage/myhomepage_bloc.dart';
import 'package:ACI/Bloc/Profilepage/profile_bloc.dart';
import 'package:ACI/Bloc/Profilepage/profile_bloc.dart';
import 'package:ACI/Bloc/Resorceview/resource_view_bloc.dart';
import 'package:ACI/Bloc/addresource/add_resouce_bloc.dart';
import 'package:ACI/Bloc/login/login_bloc.dart';
import 'package:ACI/Bloc/login/login_bloc.dart';
import 'package:ACI/Bloc/login/signin_mobile_view.dart';
import 'package:ACI/Bloc/message/app_messages_bloc.dart';
import 'package:ACI/Bloc/user/auth.dart';
import 'package:ACI/Bloc/user/auth.dart';
import 'package:ACI/Bloc/user/user_repository.dart';
import 'package:ACI/Screen/edit_profile_view.dart';
import 'package:ACI/Screen/login_init_view.dart';
import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/Screen/splash_view.dart';
import 'package:ACI/SimpleBlocObserver.dart';
import 'package:ACI/Auth_bloc.dart';
import 'package:ACI/data/globals.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.APP_BLUE, // navigation bar color
    statusBarColor: AppColors.APP_BLUE, // status bar color
  ));
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  // BlocOverrides.runZoned(
  //       () => runApp( MyApp()),
  //   blocObserver: SimpleBlocObserver(),
  // );
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ta'),
      ],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: MyApp()
  ),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MultiBlocProvider(
        providers: _multiBlocProviders(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: "Poppins",
              textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
                bodyText1: GoogleFonts.oswald(textStyle: textTheme.bodyText1),
              ),
            // primarySwatch: Colors.,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.APP_BLUE,
              elevation: 0
            )
          ),
          title: 'ACI',
          home: Auth(),
          builder: EasyLoading.init(),
        ));
  }

  List<BlocProvider<Bloc>> _multiBlocProviders() {
    UserRepository userRepository = UserRepository();
    return [
      BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)),
      BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      BlocProvider<MyhomepageBloc>(create: (context) => MyhomepageBloc()),
      BlocProvider<AddResouceBloc>(create: (context) => AddResouceBloc()),
      BlocProvider<ResourceViewBloc>(create: (context) => ResourceViewBloc()),
      BlocProvider<AppMessagesBloc>(create: (context) => AppMessagesBloc()),
    ];
  }
}

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthRequested(city: "cityname"));
              return SplashView();
            }
            if (state is AuthLoadInProgress) {
              return SplashView();
              return Center(child: CircularProgressIndicator());
            }
            if (state is AuthLoadSuccess) {
              final weather = state.AuthCheck;
              if (weather) {
                return Mydashboard();
              } else {
                return Language(from: "1");
              }
            }
            if (state is AuthLoadFailure) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            } else {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }
          },
        ),
      ),
    );
  }
}
