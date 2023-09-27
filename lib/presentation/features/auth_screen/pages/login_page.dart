// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/presentation/features/auth_screen/bloc/auth_bloc.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  
  final String? errorMsg;

  const LoginPage({
    super.key,
    this.errorMsg
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _errorTextVisibility = false;
  double _errorTextHeight = 160;

  bool _passwordVisibility = true;

  late TextEditingController _usernameOrEmailController;
  late TextEditingController _passwordController;

  String? _usernameValidatorErrorMsg;
  String? _passwordValidatorErrorMsg;

  @override
  void initState() {
    super.initState();
    
    //_errorTextVisibility = widget.errorMsg == null ? false : true;
    _usernameOrEmailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  OutlineInputBorder _buildInputBorderStyle() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190), width: 1),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [ Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        child: OverflowBox(
                          minHeight: 160,
                          maxHeight: 160,
                          child: LottieBuilder.asset(
                            'assets/animations/splash_screen_animation.json',
                            //height: 160,
                            repeat: false,
                          ),
                        ),
                      ),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Let\'s log you in',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        )
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            // username textfield
                            TextField(
                              key: Key(_usernameOrEmailController.hashCode.toString()),
                              controller: _usernameOrEmailController,
                              autocorrect: false,
                              style: const TextStyle(
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                enabledBorder: _buildInputBorderStyle(),
                                focusedBorder: _buildInputBorderStyle(),
                                errorBorder: _buildInputBorderStyle(),
                                focusedErrorBorder: _buildInputBorderStyle(),
                                errorText: _usernameValidatorErrorMsg,
                                errorStyle: const TextStyle(
                                  fontSize: 14
                                ),
                                label: const Text(
                                  'Username or email ID',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 168, 170, 179),
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ),
                            ),
                            const SizedBox(height: 35),
                            // email textfield
                            TextField(
                              key: Key(_passwordController.hashCode.toString()),
                              controller: _passwordController,
                              obscureText: _passwordVisibility,
                              keyboardType: TextInputType.visiblePassword,
                              autocorrect: false,
                              style: const TextStyle(
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                enabledBorder: _buildInputBorderStyle(),
                                focusedBorder: _buildInputBorderStyle(),
                                errorBorder: _buildInputBorderStyle(),
                                focusedErrorBorder: _buildInputBorderStyle(),
                                errorText: _passwordValidatorErrorMsg,
                                errorStyle: const TextStyle(
                                  fontSize: 14
                                ),
                                label: const Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 168, 170, 179),
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisibility = !_passwordVisibility;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordVisibility ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                    color: const Color.fromARGB(255, 151, 151, 151)
                                  ),
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 25,
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 145, 145, 145),
                              fontWeight: FontWeight.w500
                            ),
                            children: [
                              TextSpan(
                                text: ' Register',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 26, 27, 39),
                                  fontWeight: FontWeight.w700
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  BlocProvider.of<AuthBloc>(context).add(AuthNavigateToSignUpEvent());
                                }
                              )
                            ]
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _logInHandler,
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 26, 27, 39)),
                            fixedSize: const MaterialStatePropertyAll(Size(300, 45)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                          ),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        //const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: _errorTextVisibility,
                child: Container(
                  width: 300,
                  height: _errorTextHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [BoxShadow(
                      color: const Color(0x008b8b8b).withOpacity(1),
                      offset: const Offset(8, 9),
                      blurRadius: 16,
                      spreadRadius: 4,
                    )],
                  ),
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      const Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          widget.errorMsg?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _errorTextVisibility = false;
                          });
                        },
                        child: const Text(
                          'Dismiss',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      )
                    ],
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

  void _logInHandler() {
    
    final String _usernameOrEmailControllerData = _usernameOrEmailController.text.trim();
    final String _passwordControllerData = _passwordController.text.trim();

    if (_usernameOrEmailControllerData != '' && _passwordControllerData != '') {

      String? _username, _userMailId;

      if (_usernameOrEmailControllerData.contains('@')) {
        _userMailId = _usernameOrEmailControllerData;
      } else {
        _username = _usernameOrEmailControllerData;
      }

      BlocProvider.of<AuthBloc>(context).add(AuthLogInRequest(
        username: _username,
        mailId: _userMailId,
        password: _passwordControllerData,
      ));
    } else if (_usernameOrEmailControllerData == '' && _passwordControllerData == '') {
      setState(() {
        if (_errorTextVisibility) {
          _errorTextVisibility = false;
        }
        _usernameValidatorErrorMsg = 'Username field is required';
        _passwordValidatorErrorMsg = 'email ID field is required';
      });
    } else if (_usernameOrEmailControllerData == '') {
      setState(() {
        if (_errorTextVisibility) {
          _errorTextVisibility = false;
        }
        _usernameValidatorErrorMsg = 'Username field is required';
      });
    } else if (_passwordControllerData == '') {
      setState(() {
        if (_errorTextVisibility) {
          _errorTextVisibility = false;
        }
        _passwordValidatorErrorMsg = 'Username field is required';
      });
    }
  }

  @override
  void didUpdateWidget(covariant LoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMsg != null) {
      setState(() {
        _errorTextVisibility = true;
        if (widget.errorMsg!.toString().length > 30) {
          _errorTextHeight = 220;
        } else {
          _errorTextHeight = 160;
        }

        _usernameValidatorErrorMsg = _passwordValidatorErrorMsg = null;
      });
    }
  }
}