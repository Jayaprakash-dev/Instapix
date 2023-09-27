import 'package:flutter/material.dart';
import 'package:gallery/presentation/features/auth_screen/pages/login_page.dart';
import 'package:gallery/presentation/features/auth_screen/pages/signup_page.dart';
import 'package:gallery/presentation/features/home_screen/bloc/home_bloc.dart';
import 'package:gallery/presentation/features/home_screen/home_screen.dart';
import 'package:gallery/presentation/features/home_screen/pages/post_page.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/post':
        return MaterialPageRoute(builder: (_) => PostPage(homeBloc: settings.arguments! as HomeBloc));
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}