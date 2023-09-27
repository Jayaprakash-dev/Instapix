import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery/config/app_routes.dart';
import 'package:gallery/presentation/features/auth_screen/bloc/auth_bloc.dart';
import 'package:gallery/presentation/features/auth_screen/pages/login_page.dart';
import 'package:gallery/presentation/features/auth_screen/pages/registration_error_page.dart';
import 'package:gallery/presentation/features/auth_screen/pages/registration_status_page.dart';
import 'package:gallery/presentation/features/auth_screen/pages/signup_page.dart';
import 'package:gallery/presentation/features/home_screen/home_screen.dart';
import 'package:gallery/service_locator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  loadDependencies();
  //WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocDelegate();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(MediaQuery.of(context).size);

    return FutureBuilder(
      future: services.allReady(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          final bool? userLoginStatus = services<SharedPreferences>().getBool('userLoginStatus');
          // ignore: avoid_print
          print('userLoginStatus: $userLoginStatus');

          return BlocProvider<AuthBloc>(
            create: (_) => services<AuthBloc>()..add(AppStarted()),
            child: ScreenUtilInit(
              designSize: const Size(390.0, 844.0),
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,       
                  onGenerateRoute: AppRoutes.onGenerateRoutes,
                  home: AnimatedSplashScreen(
                    splash: LottieBuilder.asset(
                      'assets/animations/splash_screen_animation.json',
                      height: 300, width: 300,
                    ),
                    nextScreen: _authBlocBuilder(),
                    splashTransition: SplashTransition.fadeTransition,
                    pageTransitionType: PageTransitionType.bottomToTop,
                    curve: Curves.easeOut,
                    splashIconSize: 400,
                    duration: 3000,
                    //centered: false,
                  )
                );
              }
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }

        return const Center(child : CircularProgressIndicator(color: Colors.blue));
      }
    );
  }

  Widget _authBlocBuilder() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case UserAuthenticated:
            return const HomeScreen();
          case UnAuthenticatedSignUp:
            return const SignupPage();
          case UnAuthenticatedLogIn || UserLoggedOut:
            return const LoginPage();
          case RegisteringUser:
            return RegistrationStatusPage(status: (state as RegisteringUser).status);
          case UserRegistrationException:
            return const RegistrationErrorPage();
          case UserLogInException:
            return LoginPage(errorMsg: (state as UserLogInException).errorMsg.toString());
          default:
            return const SignupPage();
        }
      },
    );
  }
}

class BlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // ignore: avoid_print
    print(error);
  }
}