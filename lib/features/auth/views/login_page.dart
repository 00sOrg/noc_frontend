import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/features/auth/viewmodels/login_viewmodel.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _redirectToLogin(WidgetRef ref) async {
    final loginUrl = ref.read(loginViewModelProvider.notifier).loginUrl;
    html.window.location.assign(loginUrl);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w),
        child: Center(
          child: ElevatedButton.icon(
            label: const Text('구글 계정으로 로그인'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 48.h),
              side: const BorderSide(color: Colors.grey),
            ),
            onPressed: () => _redirectToLogin(ref),
          ),
        ),
      ),
    );
  }
}
