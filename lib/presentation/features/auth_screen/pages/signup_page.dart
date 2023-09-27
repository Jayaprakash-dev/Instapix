// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery/domain/usecases/authentication_usecases/user_validator.dart';
import 'package:gallery/presentation/features/auth_screen/bloc/auth_bloc.dart';
import 'package:gallery/service_locator.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  bool _passwordVisibility = true;
  bool _confirmPasswordVisibility = true;

  // textfield controllers
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isUsernameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  String? _usernameValidatorErrorMsg;
  String? _emailValidatorErrorMsg;
  String? _passwordValidatorErrorMsg;
  String? _confirmPasswordValidatorErrorMsg;

  @override
  void initState() {
    super.initState();

    // textfield controllers
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

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
      body: _buildSignupBody()
    );
  }

  Widget _buildSignupBody() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
        color: const Color.fromARGB(255, 243, 243, 243),
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
                  'Create Your Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Let\'s register you in',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.w),
                  child: Column(
                    children: [
                      // username textfield
                      TextField(
                        controller: _usernameController,
                        autocorrect: false,
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          enabledBorder: _buildInputBorderStyle(),
                          focusedBorder: _buildInputBorderStyle(),
                          errorBorder: _buildInputBorderStyle(),
                          focusedErrorBorder: _buildInputBorderStyle(),
                          label: const Text(
                            'Username',
                            style: TextStyle(
                              color: Color.fromARGB(255, 168, 170, 179),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          errorText: !_isUsernameValid ? _usernameValidatorErrorMsg : null,
                          errorStyle: const TextStyle(
                            fontSize: 14
                          ),
                        ),
                        onChanged: _usernameValidator,
                      ),
                      const SizedBox(height: 25),
                      // email textfield
                      TextField(
                        controller: _emailController,
                        autocorrect: false,
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          enabledBorder: _buildInputBorderStyle(),
                          focusedBorder: _buildInputBorderStyle(),
                          errorBorder: _buildInputBorderStyle(),
                          focusedErrorBorder: _buildInputBorderStyle(),
                          errorText: !_isEmailValid ? _emailValidatorErrorMsg : null,
                          errorStyle: const TextStyle(
                            fontSize: 14
                          ),
                          label: const Text(
                            'email ID',
                            style: TextStyle(
                              color: Color.fromARGB(255, 168, 170, 179),
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ),
                        onChanged: _emailValidator,
                      ),
                      const SizedBox(height: 25),
                      // password textfield
                      TextField(
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
                          errorText: !_isPasswordValid ? _passwordValidatorErrorMsg : null,
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
                        onChanged: _passwordValidator,
                      ),
                      const SizedBox(height: 25),
                      // confirm password textfield
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _confirmPasswordVisibility,
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
                          errorText: !_isConfirmPasswordValid ? _confirmPasswordValidatorErrorMsg : null,
                          errorStyle: const TextStyle(
                            fontSize: 14,
                          ),
                          errorMaxLines: 2,
                          label: const Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Color.fromARGB(255, 168, 170, 179),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisibility = !_confirmPasswordVisibility;
                              });
                            },
                            icon: Icon(
                              _confirmPasswordVisibility ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                              color: const Color.fromARGB(255, 151, 151, 151)
                            ),
                          )
                        ),
                        onChanged: _confirmPasswordValidator,
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
                      text: 'Already have an account?',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 145, 145, 145),
                        fontWeight: FontWeight.w500
                      ),
                      children: [
                        TextSpan(
                          text: ' Log In',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 26, 27, 39),
                            fontWeight: FontWeight.w700
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            BlocProvider.of<AuthBloc>(context).add(AuthNavigateToLogInEvent());
                          }
                        )
                      ]
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _registerHandler,
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 26, 27, 39)),
                      fixedSize: const MaterialStatePropertyAll(Size(300, 45)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _usernameValidator(String value) {
    final RegExp regex = RegExp(r'[^\s0-9a-zA-Z_.]');
    if (regex.hasMatch(value.trim())) {
      setState(() {
        _isUsernameValid = false;
        _usernameValidatorErrorMsg = 'Username should only contain a-z, A-Z, 0-9, _, .';
      });
    } else {
      setState(() {
        _isUsernameValid = true;
        _usernameValidatorErrorMsg = null;
      });
    }
  }

  void _emailValidator(String value) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    if (emailRegex.hasMatch(value)) {
      setState(() {
        _isEmailValid = true;
        _emailValidatorErrorMsg = null;
      });
    } else {
      setState(() {
        _isEmailValid = false;
        _emailValidatorErrorMsg = 'Emaid ID is not valid';
      });
    }
  }

  void _passwordValidator(String value) {
    //final RegExp regex = RegExp(r'^(?=.*[A-Za-z0-9]).{8,}$');

    if (value.length < 8) {
      setState(() {
        _passwordValidatorErrorMsg = 'Password length must be at least 8 characters';
        _isPasswordValid = false;
      });
    } else {
      setState(() {
        _passwordValidatorErrorMsg = null;
        _isPasswordValid = true;
      });
    }
  }

  void _confirmPasswordValidator(String value) {
    if (value != _passwordController.text) {
      setState(() {
        _isConfirmPasswordValid = false;
        _confirmPasswordValidatorErrorMsg = 'Password and confirmation password does not match';
      });
    } else {
      setState(() {
        _isConfirmPasswordValid = true;
        _confirmPasswordValidatorErrorMsg = null;
      });
    }
  }

  Future<void> _registerHandler() async {

    final String _usernameControllerData = _usernameController.text.trim();
    final String _emailControllerData = _emailController.text.trim();
    final String _passwordControllerData = _passwordController.text.trim();
    final String _confirmPasswordControllerData = _confirmPasswordController.text.trim();

    if (_usernameControllerData != '' && _emailControllerData != ''
    && _passwordControllerData != '' && _confirmPasswordControllerData != ''
    && _isPasswordValid && _isConfirmPasswordValid && _isUsernameValid && _isEmailValid)
    {

      if (await _checkUser(_usernameControllerData)) {
        setState(() {
          _isUsernameValid = false;
          _usernameValidatorErrorMsg = 'Username already exists';
        });
        return;
      }

      if (await _checkUser(_emailControllerData)) {
        setState(() {
          _isEmailValid = false;
          _emailValidatorErrorMsg = "Email ID already exists";
        });
        return;
      }

      _sendRegisterReq(
        _usernameControllerData,
        _emailControllerData,
        _passwordControllerData
      );

      return;
    } else if (_usernameControllerData == '' && _emailControllerData == ''
    && _passwordControllerData == '' && _confirmPasswordControllerData == '') {
      setState(() {
        _isUsernameValid = _isEmailValid = _isPasswordValid = _isConfirmPasswordValid = false;
        _usernameValidatorErrorMsg = 'Username field is required';
        _emailValidatorErrorMsg = 'Email ID field is required';
        _passwordValidatorErrorMsg = 'Password field is required';
        _confirmPasswordValidatorErrorMsg = 'Confirmation password field is required';
      });
    } else {
      setState(() {  
        if (_usernameControllerData == '') {
          _isUsernameValid = false;
          _usernameValidatorErrorMsg = 'Username field is required';
        }

        if (_emailControllerData == '') {
          _isEmailValid = false;
          _emailValidatorErrorMsg = 'Email ID field is required';
        }

        if (_passwordControllerData == '') {
          _isPasswordValid = false;
          _passwordValidatorErrorMsg = 'Password field is required';
        }

        if (_confirmPasswordControllerData == '') {
          _isConfirmPasswordValid = false;
          _confirmPasswordValidatorErrorMsg = 'Confirmation password field is required';
        }
      });
    }

    const SnackBar snackBar = SnackBar(
      content: Text('Please fill in all fields'),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> _checkUser(String val) async {
    return await services<UserValidatorUseCase>()(param: val);
  }
  
  void _sendRegisterReq(String username, String mailId, String password) {
    BlocProvider.of<AuthBloc>(context).add(AuthRegistrationRequest(
      username: username,
      mailId: mailId,
      password: password,
    ));
  }
}