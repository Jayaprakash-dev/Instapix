import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/presentation/features/auth_screen/bloc/auth_bloc.dart';
import 'package:lottie/lottie.dart';

class RegistrationStatusPage extends StatefulWidget {
  final bool status;

  const RegistrationStatusPage({super.key, this.status=false});

  @override
  State<RegistrationStatusPage> createState() => _RegistrationStatusPageState();
}

class _RegistrationStatusPageState extends State<RegistrationStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !widget.status
      ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 26, 27, 39)))
      : Center(
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
                    LottieBuilder.asset(
                      'assets/animations/authSuccessAnimation.json',
                      width: 60, height: 60,
                      repeat: false,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your registration is successful',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
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
                    onPressed: () => BlocProvider.of<AuthBloc>(context).add(AuthSuccessEvent()),
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 26, 27, 39)),
                      fixedSize: const MaterialStatePropertyAll(Size(300, 45)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                    ),
                    child: const Text(
                      'Continue',
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