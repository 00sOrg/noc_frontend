import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/features/auth/viewmodels/login_viewmodel.dart';
import 'package:sos/shared/navigation/app_router.dart';
// import 'package:sos/shared/services/push_notification_service.dart';
import 'package:sos/shared/utils/log_util.dart';
import 'package:sos/shared/viewmodels/location_viewmodel.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  await _initialize();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // final container = ProviderContainer();
  // final pushNotificationService = container.read(pushNotificationProvider);
  // await pushNotificationService.preAppInitialization();

  // PushNotificationService pushNotificationService = PushNotificationService();
  // await pushNotificationService.preAppInitialization();

  //main.dart에서 로그인 상태 체크 완료 후 앱 실행
  // final loginVM = container.read(loginViewModelProvider.notifier);
  // await loginVM.checkLoginStatus();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    LogUtil.e("Could not load .env file: $e");
  }

  await Geolocator.checkPermission();
  await Geolocator.requestPermission();
  final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);

  debugPrint('latitude: ${position.latitude}');
  debugPrint('longitude: ${position.longitude}');

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      // final pushNotificationService = ref.read(pushNotificationProvider);
      // pushNotificationService.postAppInitialization(context, ref);
    });
    ref.read(loginViewModelProvider.notifier).checkLoginStatus();
    final locationAsyncValue = ref.watch(locationViewModelProvider);

    final appRouterProvider = Provider<GoRouter>((ref) {
      return AppRouter(ref).router();
    });

    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) {
          return MaterialApp(
            title: 'Noc',
            debugShowCheckedModeBanner: false,
            home: locationAsyncValue.when(
              data: (location) {
                return MaterialApp.router(
                  title: 'Noc',
                  routerConfig: ref.watch(appRouterProvider),
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    fontFamily: 'AppleSD',
                    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
            theme: ThemeData(
              fontFamily: 'AppleSD',
            ),
          );
        });
  }
}
