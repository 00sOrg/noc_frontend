import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos/features/auth/views/login_page.dart';
// import 'package:sos/features/auth/views/splash_page.dart';
import 'package:sos/features/board/views/board_page.dart';
import 'package:sos/features/home/views/home_page.dart';
import 'package:sos/features/setting/views/setting_page.dart';
import 'package:sos/features/setting/views/subpages/setting_deleted_account_page.dart';
import 'package:sos/features/setting/views/subpages/setting_my_post_page.dart';
import 'package:sos/features/write/viewmodels/camera_viewmodel.dart';
import 'package:sos/features/write/views/custom_camera_screen.dart';
import 'package:sos/features/write/views/image_check_page.dart';
import 'package:sos/features/write/views/write_page.dart';
import 'package:sos/shared/navigation/app_routes.dart';
import 'package:sos/shared/views/geolocator_test_page.dart';
import 'package:sos/shared/widgets/custom_nav_bar.dart';
import 'package:sos/features/post/views/post_page.dart';

class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  GoRouter router() {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/setting-deleted-account',
          builder: (context, state) => const SettingDeletedAccountPage(),
        ),
        GoRoute(
          path: '/post/:id',
          builder: (context, state) {
            final postId = int.parse(state.pathParameters['id']!);
            return PostPage(postId: postId);
          },
        ),
        GoRoute(
          path: '/custom-camera',
          builder: (context, state) => const CustomCameraScreen(),
        ),
        GoRoute(
          path: '/image-check',
          builder: (context, state) {
            final ImageCheckArguments? args =
                state.extra as ImageCheckArguments?;
            if (args != null) {
              return ImageCheckPage(
                imagePath: args.imagePath,
                viewOnly: args.viewOnly,
              );
            } else {
              return const NoImageCheckPage();
            }
          },
        ),
        GoRoute(
            path: '/write',
            builder: (context, state) {
              final XFile? camImg = state.extra as XFile?;
              return WritePage(camImg: camImg);
            }),
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              body: child,
              bottomNavigationBar: Builder(
                builder: (context) {
                  return CustomNavBar(
                    selectedIdx: calculateSelectedIdx(state.uri.path),
                  );
                },
              ),
            );
          },
          routes: _routes,
        ),
      ],
    );
  }

  static List<GoRoute> get _routes => [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
            path: '/write',
            builder: (context, state) {
              final XFile? camImg = state.extra as XFile?;
              return WritePage(camImg: camImg);
            }),
        GoRoute(
          path: '/board',
          builder: (context, state) => const BoardPage(),
        ),
        GoRoute(
          path: '/setting',
          builder: (context, state) => const SettingPage(),
        ),
        GoRoute(
          path: '/setting-my-post',
          builder: (context, state) => const SettingMyPostPage(),
        ),
        GoRoute(
          path: '/location-test',
          builder: (context, state) => const GeolocatorTestPage(),
        ),
      ];

  static int calculateSelectedIdx(String location) {
    return AppRoutesExtension.fromPath(location).index;
  }
}
