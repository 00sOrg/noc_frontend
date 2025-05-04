enum AppRoutes {
  home,
  write,
  board,
}

extension AppRoutesExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.home:
        return '/home';
      case AppRoutes.write:
        return '/write';
      case AppRoutes.board:
        return '/board';
      default:
        return '/';
    }
  }

  static AppRoutes fromPath(String path) {
    switch (path) {
      case '/home':
        return AppRoutes.home;
      case '/write':
        return AppRoutes.write;
      case '/board':
        return AppRoutes.board;
      default:
        return AppRoutes.home;
    }
  }
}
