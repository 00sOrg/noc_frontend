import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sos/features/home/viewmodels/home_viewmodel.dart';
import 'package:sos/features/home/views/widgets/header_btn.dart';
import 'package:sos/features/home/views/widgets/map_area.dart';
import 'package:sos/shared/viewmodels/location_viewmodel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(userViewModelProvider.notifier).loadUserInfo();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationAsyncValue = ref.watch(locationViewModelProvider);

    return KeyboardDismisser(
      child: Scaffold(
        body: Stack(
          children: [
            locationAsyncValue.when(
              data: (location) {
                return Stack(
                  children: [
                    // MapWidget에 위치와 Post 리스트를 전달합니다.
                    MapWidget(
                      currentLocation: location,
                    ),
                    _homeTopArea(context, ref),
                  ],
                );
              },
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _homeTopArea(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 60,
      left: 15,
      right: 15,
      child: Column(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HeaderBtn(
                    onTap: () async {
                      final isLoggedIn = await ref
                          .read(homeViewModelProvider.notifier)
                          .checkLoginStatus();
                      if (isLoggedIn) {
                        context.go('/setting');
                      } else {
                        context.go('/login');
                      }
                    },
                    icon: Image.asset(
                      'assets/icons/home/favorites.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
