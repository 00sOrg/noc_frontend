import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sos/features/auth/viewmodels/login_viewmodel.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    return KeyboardDismisser(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 71.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Google 로그인 버튼
              ElevatedButton.icon(
                label: const Text('구글 계정으로 로그인'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 48.h),
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: loginState.isLoading
                    ? null
                    : () => loginViewModel.handleGoogleLogin(context),
              ),

              const SizedBox(height: 20),
              if (loginState.isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
