import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/features/auth/viewmodels/login_viewmodel.dart';

class RedirectHandlerPage extends ConsumerStatefulWidget {
  const RedirectHandlerPage({super.key});

  @override
  ConsumerState<RedirectHandlerPage> createState() =>
      _RedirectHandlerPageState();
}

class _RedirectHandlerPageState extends ConsumerState<RedirectHandlerPage> {
  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  void _handleRedirect() {
    final uri = Uri.base;

    final accessToken = uri.queryParameters['accessToken'];
    final refreshToken = uri.queryParameters['refreshToken'];

    if (accessToken != null && refreshToken != null) {
      final loginVM = ref.read(loginViewModelProvider.notifier);
      loginVM.storeTokens(accessToken, refreshToken).then((_) {
        context.go('/home');
      });
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
