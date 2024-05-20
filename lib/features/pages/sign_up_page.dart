import 'package:clario_flutter_test/common/app_assets.dart';
import 'package:clario_flutter_test/common/app_colors.dart';
import 'package:clario_flutter_test/common/app_spacing.dart';
import 'package:clario_flutter_test/common/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  InputState _emailState = InputState.initial;
  InputState _passwordState = InputState.initial;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.backgroundGradientColors,
                stops: [0, 1],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppAssets.starsBackground),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.mediumLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign Up',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainText,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Form(
                    child: Column(
                      children: [
                        TextInputField.email(
                          controller: _emailController,
                          inputState: _emailState,
                          onChanged: (_) =>
                              setState(() => _emailState = InputState.initial),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        if (_emailState == InputState.error) ...[
                          Text(
                            'Please enter a valid email address',
                            style: GoogleFonts.inter(
                              color: AppColors.errorText,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.medium),
                        ],
                        TextInputField.password(
                          controller: _passwordController,
                          inputState: _passwordState,
                          onChanged: (_) => setState(
                              () => _passwordState = InputState.initial),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        if (_passwordState == InputState.error)
                          Text(
                            'This password doesn\'t look right.\nPlease try again or reset it now.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AppColors.errorText,
                              fontSize: 16,
                            ),
                          ),
                        if (_passwordState != InputState.error)
                          ValueListenableBuilder(
                            valueListenable: _passwordController,
                            builder: (context, value, _) => Align(
                              alignment: Alignment.centerLeft,
                              child: _PasswordCriteriasView(
                                password: value.text,
                              ),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.large),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _emailState =
                                  _validateEmail(_emailController.text)
                                      ? InputState.success
                                      : InputState.error;
                              _passwordState =
                                  _validatePassword(_passwordController.text)
                                      ? InputState.success
                                      : InputState.error;
                            });

                            if (_emailState == InputState.success &&
                                _passwordState == InputState.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sign Up successful'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 240,
                            height: 48,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                end: Alignment.centerRight,
                                colors: AppColors.buttonGradientColors,
                                stops: [0, 1],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateEmail(String email) {
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regex = RegExp(pattern);

    if (email.isEmpty) {
      return false;
    }

    return regex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 8 &&
        !password.contains(' ') &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }
}

class _PasswordCriteriasView extends StatelessWidget {
  const _PasswordCriteriasView({
    super.key,
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PasswordCriteria(
          text: '8 characters or more (no spaces)',
          isFulfilled: password.length >= 8 && !password.contains(' '),
        ),
        _PasswordCriteria(
          text: 'Uppercase and lowercase letters',
          isFulfilled: password.contains(RegExp(r'[A-Z]')) &&
              password.contains(RegExp(r'[a-z]')),
        ),
        _PasswordCriteria(
          text: 'At least one digit',
          isFulfilled: password.contains(RegExp(r'[0-9]')),
        ),
      ],
    );
  }
}

class _PasswordCriteria extends StatelessWidget {
  const _PasswordCriteria({
    super.key,
    required this.text,
    required this.isFulfilled,
  });

  final String text;
  final bool isFulfilled;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: isFulfilled
            ? AppColors.successText.withOpacity(0.7)
            : AppColors.mainText,
        fontSize: 16,
      ),
    );
  }
}
