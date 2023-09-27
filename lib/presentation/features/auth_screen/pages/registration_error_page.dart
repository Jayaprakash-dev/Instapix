import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/presentation/features/auth_screen/bloc/auth_bloc.dart';
import 'package:lottie/lottie.dart';

class RegistrationErrorPage extends StatefulWidget {

  const RegistrationErrorPage({super.key});

  @override
  State<RegistrationErrorPage> createState() => _RegistrationErrorPageState();
}

class _RegistrationErrorPageState extends State<RegistrationErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/authErrorAnimation.json',
                      width: 60, height: 60,
                      repeat: false,
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        'Your registration is incomplete. Something went wrong.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: TextButton(
                    onPressed: () => BlocProvider.of<AuthBloc>(context).add(AuthNavigateToSignUpEvent()),
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 26, 27, 39)),
                      fixedSize: const MaterialStatePropertyAll(Size(300, 45)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}